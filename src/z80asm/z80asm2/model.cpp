//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "model.h"
#include "utils.h"
#include <cassert>
#include <cmath>
#include <sstream>

// integer power helper (fast exponentiation). negative exponent -> 0
static int ipow(int base, int exp) {
    if (exp < 0) {
        return 0;
    }
    long long acc = 1;
    long long b = base;
    while (exp) {
        if (exp & 1) {
            acc *= b;
        }
        exp >>= 1;
        b *= b;
    }
    return static_cast<int>(acc);
}

//-----------------------------------------------------------------------------
// Concrete expression node classes (private implementation)
//-----------------------------------------------------------------------------

namespace {

// Integer literal - always constant
class IntegerNode : public ExprNode {
public:
    explicit IntegerNode(int value) : value_(value) {}

    ExprOp op() const override {
        return ExprOp::Integer;
    }

    int evaluate() const override {
        return value_;
    }

    bool is_constant() const override {
        return true;  // Integer literals are always constant
    }

    std::unique_ptr<ExprNode> clone() const override {
        return std::make_unique<IntegerNode>(value_);
    }

    std::string to_string() const override {
        return std::to_string(value_);
    }

private:
    int value_;
};

// Symbol reference (by pointer - always resolved during parsing)
class SymbolNode : public ExprNode {
public:
    explicit SymbolNode(Symbol* symbol) : symbol_(symbol) {}

    ExprOp op() const override {
        return ExprOp::Symbol;
    }

    int evaluate() const override {
        if (!symbol_) {
            throw UndefinedSymbol("<null>");
        }

        // Call Symbol::evaluate() which is now const
        return symbol_->evaluate();
    }

    bool is_constant() const override {
        if (!symbol_) {
            return false;
        }

        // Check if symbol is defined
        if (symbol_->is_undefined()) {
            return false;
        }

        // Check symbol type
        switch (symbol_->type()) {
        case SymbolType::Constant:
            return true;  // Constants are always constant

        case SymbolType::AddressRelative:
            return false;  // Labels are not constant (address depends on link time)

        case SymbolType::Computed:
            // Computed symbols are constant if their expression is constant
            return symbol_->has_expression() && symbol_->expression().is_constant();

        case SymbolType::Undefined:
        default:
            return false;
        }
    }

    std::unique_ptr<ExprNode> clone() const override {
        return std::make_unique<SymbolNode>(symbol_);
    }

    std::string to_string() const override {
        return symbol_ ? symbol_->name() : "<null>";
    }

    Symbol* symbol() const {
        return symbol_;
    }

private:
    Symbol* symbol_;
};

// Dollar (current location) - always resolved during parsing
class DollarNode : public ExprNode {
public:
    explicit DollarNode(Opcode* opcode, Section* section)
        : opcode_(opcode), section_(section) {}

    ExprOp op() const override {
        return ExprOp::Dollar;
    }

    int evaluate() const override {
        if (!section_ || !opcode_) {
            throw InvalidDollar();
        }

        // Calculate address: section base + opcode's offset in section
        int offset = 0;
        for (const auto& op : section_->opcodes()) {
            if (op.get() == opcode_) {
                return section_->base_address() + offset;
            }
            offset += static_cast<int>(op->size());
        }

        throw InvalidDollar();  // Opcode not found in section
    }

    bool is_constant() const override {
        return false;  // $ depends on assembly location, not constant
    }

    std::unique_ptr<ExprNode> clone() const override {
        return std::make_unique<DollarNode>(opcode_, section_);
    }

    std::string to_string() const override {
        return "$";
    }

private:
    Opcode* opcode_;
    Section* section_;
};

// Unary operator
class UnaryOpNode : public ExprNode {
public:
    UnaryOpNode(ExprOp op, std::unique_ptr<ExprNode> operand)
        : op_(op), operand_(std::move(operand)) {}

    ExprOp op() const override {
        return op_;
    }

    int evaluate() const override {
        int val = operand_->evaluate();

        switch (op_) {
        case ExprOp::UnaryPlus:
            return val;
        case ExprOp::UnaryMinus:
            return -val;
        case ExprOp::LogicalNot:
            return !val;
        case ExprOp::BitwiseNot:
            return ~val;
        default:
            throw ExpressionError("Invalid unary operator");
        }
    }

    bool is_constant() const override {
        return operand_->is_constant();  // Unary op is constant if operand is constant
    }

    std::unique_ptr<ExprNode> clone() const override {
        return std::make_unique<UnaryOpNode>(op_, operand_->clone());
    }

    std::string to_string() const override {
        const char* op_str = "?";
        switch (op_) {
        case ExprOp::UnaryPlus:
            op_str = "+";
            break;
        case ExprOp::UnaryMinus:
            op_str = "-";
            break;
        case ExprOp::LogicalNot:
            op_str = "!";
            break;
        case ExprOp::BitwiseNot:
            op_str = "~";
            break;
        default:
            break;
        }
        return std::string(op_str) + "(" + operand_->to_string() + ")";
    }

private:
    ExprOp op_;
    std::unique_ptr<ExprNode> operand_;
};

// Binary operator
class BinaryOpNode : public ExprNode {
public:
    BinaryOpNode(ExprOp op, std::unique_ptr<ExprNode> left,
                 std::unique_ptr<ExprNode> right)
        : op_(op), left_(std::move(left)), right_(std::move(right)) {}

    ExprOp op() const override {
        return op_;
    }

    int evaluate() const override {
        int left_val = left_->evaluate();
        int right_val = right_->evaluate();

        switch (op_) {
        case ExprOp::Power:
            return ipow(left_val, right_val);
        case ExprOp::Multiply:
            return left_val * right_val;
        case ExprOp::Divide:
            if (right_val == 0) {
                throw DivisionByZero();
            }
            return left_val / right_val;
        case ExprOp::Modulo:
            if (right_val == 0) {
                throw DivisionByZero();
            }
            return left_val % right_val;
        case ExprOp::Add:
            return left_val + right_val;
        case ExprOp::Subtract:
            return left_val - right_val;
        case ExprOp::LeftShift:
            return left_val << right_val;
        case ExprOp::RightShift:
            return left_val >> right_val;
        case ExprOp::LessThan:
            return left_val < right_val;
        case ExprOp::LessOrEqual:
            return left_val <= right_val;
        case ExprOp::GreaterThan:
            return left_val > right_val;
        case ExprOp::GreaterOrEqual:
            return left_val >= right_val;
        case ExprOp::Equal:
            return left_val == right_val;
        case ExprOp::NotEqual:
            return left_val != right_val;
        case ExprOp::BitwiseAnd:
            return left_val & right_val;
        case ExprOp::BitwiseXor:
            return left_val ^ right_val;
        case ExprOp::BitwiseOr:
            return left_val | right_val;
        case ExprOp::LogicalAnd:
            return left_val && right_val;
        case ExprOp::LogicalOr:
            return left_val || right_val;
        case ExprOp::LogicalXor:
            return (left_val ? 1 : 0) ^ (right_val ? 1 : 0);
        default:
            throw ExpressionError("Invalid binary operator");
        }
    }

    bool is_constant() const override {
        // Binary op is constant if both operands are constant
        return left_->is_constant() && right_->is_constant();
    }

    std::unique_ptr<ExprNode> clone() const override {
        return std::make_unique<BinaryOpNode>(op_, left_->clone(), right_->clone());
    }

    std::string to_string() const override {
        const char* op_str = "?";
        switch (op_) {
        case ExprOp::Power:
            op_str = "**";
            break;
        case ExprOp::Multiply:
            op_str = "*";
            break;
        case ExprOp::Divide:
            op_str = "/";
            break;
        case ExprOp::Modulo:
            op_str = "%";
            break;
        case ExprOp::Add:
            op_str = "+";
            break;
        case ExprOp::Subtract:
            op_str = "-";
            break;
        case ExprOp::LeftShift:
            op_str = "<<";
            break;
        case ExprOp::RightShift:
            op_str = ">>";
            break;
        case ExprOp::LessThan:
            op_str = "<";
            break;
        case ExprOp::LessOrEqual:
            op_str = "<=";
            break;
        case ExprOp::GreaterThan:
            op_str = ">";
            break;
        case ExprOp::GreaterOrEqual:
            op_str = ">=";
            break;
        case ExprOp::Equal:
            op_str = "==";
            break;
        case ExprOp::NotEqual:
            op_str = "!=";
            break;
        case ExprOp::BitwiseAnd:
            op_str = "&";
            break;
        case ExprOp::BitwiseXor:
            op_str = "^";
            break;
        case ExprOp::BitwiseOr:
            op_str = "|";
            break;
        case ExprOp::LogicalAnd:
            op_str = "&&";
            break;
        case ExprOp::LogicalOr:
            op_str = "||";
            break;
        case ExprOp::LogicalXor:
            op_str = "^^";
            break;
        default:
            break;
        }
        return "(" + left_->to_string() + " " + op_str + " " + right_->to_string() +
               ")";
    }

private:
    ExprOp op_;
    std::unique_ptr<ExprNode> left_;
    std::unique_ptr<ExprNode> right_;
};

// Ternary conditional operator
class ConditionalNode : public ExprNode {
public:
    ConditionalNode(std::unique_ptr<ExprNode> condition,
                    std::unique_ptr<ExprNode> true_expr,
                    std::unique_ptr<ExprNode> false_expr)
        : condition_(std::move(condition)),
          true_expr_(std::move(true_expr)),
          false_expr_(std::move(false_expr)) {}

    ExprOp op() const override {
        return ExprOp::Conditional;
    }

    int evaluate() const override {
        int cond_val = condition_->evaluate();

        if (cond_val) {
            return true_expr_->evaluate();
        }
        else {
            return false_expr_->evaluate();
        }
    }

    bool is_constant() const override {
        // Ternary is constant if all three parts are constant
        return condition_->is_constant() &&
               true_expr_->is_constant() &&
               false_expr_->is_constant();
    }

    std::unique_ptr<ExprNode> clone() const override {
        return std::make_unique<ConditionalNode>(
                   condition_->clone(),
                   true_expr_->clone(),
                   false_expr_->clone()
               );
    }

    std::string to_string() const override {
        return "(" + condition_->to_string() + " ? " +
               true_expr_->to_string() + " : " +
               false_expr_->to_string() + ")";
    }

private:
    std::unique_ptr<ExprNode> condition_;
    std::unique_ptr<ExprNode> true_expr_;
    std::unique_ptr<ExprNode> false_expr_;
};

} // anonymous namespace

//-----------------------------------------------------------------------------
// Factory functions
//-----------------------------------------------------------------------------

std::unique_ptr<ExprNode> make_integer(int value) {
    return std::make_unique<IntegerNode>(value);
}

std::unique_ptr<ExprNode> make_symbol(Symbol* symbol) {
    return std::make_unique<SymbolNode>(symbol);
}

std::unique_ptr<ExprNode> make_dollar(Opcode* opcode, Section* section) {
    return std::make_unique<DollarNode>(opcode, section);
}

std::unique_ptr<ExprNode> make_unary_op(ExprOp op,
                                        std::unique_ptr<ExprNode> operand) {
    return std::make_unique<UnaryOpNode>(op, std::move(operand));
}

std::unique_ptr<ExprNode> make_binary_op(ExprOp op,
        std::unique_ptr<ExprNode> left,
        std::unique_ptr<ExprNode> right) {
    return std::make_unique<BinaryOpNode>(op, std::move(left), std::move(right));
}

std::unique_ptr<ExprNode> make_conditional(std::unique_ptr<ExprNode> condition,
        std::unique_ptr<ExprNode> true_expr,
        std::unique_ptr<ExprNode> false_expr) {
    return std::make_unique<ConditionalNode>(
               std::move(condition),
               std::move(true_expr),
               std::move(false_expr)
           );
}

//-----------------------------------------------------------------------------
// Expression Parser (Recursive Descent)
//-----------------------------------------------------------------------------

namespace {

class ExprParser {
public:
    ExprParser(const TokenLine& line, size_t& i, Module* module, Section* section)
        : line_(line), i_(i), start_i_(i), module_(module), section_(section) {}

    std::unique_ptr<ExprNode> parse() {
        auto result = parse_ternary();
        if (!result) {
            i_ = start_i_; // Reset on failure
        }
        return result;
    }

private:
    const TokenLine& line_;
    size_t& i_;
    size_t start_i_;
    Module* module_;
    Section* section_;

    bool at_end() const {
        return i_ >= line_.tokens().size();
    }
    const Token& current() const {
        return line_.tokens()[i_];
    }

    bool match(TokenType type) {
        if (at_end()) {
            return false;
        }
        if (current().is(type)) {
            ++i_;
            return true;
        }
        return false;
    }

    // Precedence levels (lowest to highest)
    std::unique_ptr<ExprNode> parse_ternary();        // ? :
    std::unique_ptr<ExprNode> parse_logical_or();     // ||
    std::unique_ptr<ExprNode> parse_logical_xor();    // ^^
    std::unique_ptr<ExprNode> parse_logical_and();    // &&
    std::unique_ptr<ExprNode> parse_bitwise_or();     // |
    std::unique_ptr<ExprNode> parse_bitwise_xor();    // ^
    std::unique_ptr<ExprNode> parse_bitwise_and();    // &
    std::unique_ptr<ExprNode> parse_equality();       // == !=
    std::unique_ptr<ExprNode> parse_relational();     // < <= > >=
    std::unique_ptr<ExprNode> parse_shift();          // << >>
    std::unique_ptr<ExprNode> parse_additive();       // + -
    std::unique_ptr<ExprNode> parse_multiplicative(); // * / %
    std::unique_ptr<ExprNode> parse_power();          // **
    std::unique_ptr<ExprNode> parse_unary();          // + - ! ~
    std::unique_ptr<ExprNode> parse_primary();
};

std::unique_ptr<ExprNode> ExprParser::parse_ternary() {
    auto condition = parse_logical_or();
    if (!condition) {
        return nullptr;
    }

    if (match(TokenType::Question)) {
        auto true_expr = parse_ternary();
        if (!true_expr) {
            return nullptr;
        }

        if (!match(TokenType::Colon)) {
            return nullptr;
        }

        auto false_expr = parse_ternary();
        if (!false_expr) {
            return nullptr;
        }

        return make_conditional(
                   std::move(condition),
                   std::move(true_expr),
                   std::move(false_expr)
               );
    }

    return condition;
}

std::unique_ptr<ExprNode> ExprParser::parse_logical_or() {
    auto left = parse_logical_xor();
    if (!left) {
        return nullptr;
    }

    while (match(TokenType::LogicalOr)) {
        auto right = parse_logical_xor();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(ExprOp::LogicalOr, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_logical_xor() {
    auto left = parse_logical_and();
    if (!left) {
        return nullptr;
    }

    while (match(TokenType::LogicalXor)) {
        auto right = parse_logical_and();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(ExprOp::LogicalXor, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_logical_and() {
    auto left = parse_bitwise_or();
    if (!left) {
        return nullptr;
    }

    while (match(TokenType::LogicalAnd)) {
        auto right = parse_bitwise_or();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(ExprOp::LogicalAnd, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_bitwise_or() {
    auto left = parse_bitwise_xor();
    if (!left) {
        return nullptr;
    }

    while (match(TokenType::BitwiseOr)) {
        auto right = parse_bitwise_xor();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(ExprOp::BitwiseOr, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_bitwise_xor() {
    auto left = parse_bitwise_and();
    if (!left) {
        return nullptr;
    }

    while (match(TokenType::BitwiseXor)) {
        auto right = parse_bitwise_and();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(ExprOp::BitwiseXor, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_bitwise_and() {
    auto left = parse_equality();
    if (!left) {
        return nullptr;
    }

    while (match(TokenType::BitwiseAnd)) {
        auto right = parse_equality();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(ExprOp::BitwiseAnd, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_equality() {
    auto left = parse_relational();
    if (!left) {
        return nullptr;
    }

    while (!at_end()) {
        ExprOp op;
        if (match(TokenType::EQ)) {
            op = ExprOp::Equal;
        }
        else if (match(TokenType::NE)) {
            op = ExprOp::NotEqual;
        }
        else {
            break;
        }

        auto right = parse_relational();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(op, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_relational() {
    auto left = parse_shift();
    if (!left) {
        return nullptr;
    }

    while (!at_end()) {
        ExprOp op;
        if (match(TokenType::LT)) {
            op = ExprOp::LessThan;
        }
        else if (match(TokenType::LE)) {
            op = ExprOp::LessOrEqual;
        }
        else if (match(TokenType::GT)) {
            op = ExprOp::GreaterThan;
        }
        else if (match(TokenType::GE)) {
            op = ExprOp::GreaterOrEqual;
        }
        else {
            break;
        }

        auto right = parse_shift();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(op, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_shift() {
    auto left = parse_additive();
    if (!left) {
        return nullptr;
    }

    while (!at_end()) {
        ExprOp op;
        if (match(TokenType::LeftShift)) {
            op = ExprOp::LeftShift;
        }
        else if (match(TokenType::RightShift)) {
            op = ExprOp::RightShift;
        }
        else {
            break;
        }

        auto right = parse_additive();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(op, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_additive() {
    auto left = parse_multiplicative();
    if (!left) {
        return nullptr;
    }

    while (!at_end()) {
        ExprOp op;
        if (match(TokenType::Plus)) {
            op = ExprOp::Add;
        }
        else if (match(TokenType::Minus)) {
            op = ExprOp::Subtract;
        }
        else {
            break;
        }

        auto right = parse_multiplicative();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(op, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_multiplicative() {
    auto left = parse_power();
    if (!left) {
        return nullptr;
    }

    while (!at_end()) {
        ExprOp op;
        if (match(TokenType::Multiply)) {
            op = ExprOp::Multiply;
        }
        else if (match(TokenType::Divide)) {
            op = ExprOp::Divide;
        }
        else if (match(TokenType::Modulo)) {
            op = ExprOp::Modulo;
        }
        else {
            break;
        }

        auto right = parse_power();
        if (!right) {
            return nullptr;
        }
        left = make_binary_op(op, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_power() {
    auto left = parse_unary();
    if (!left) {
        return nullptr;
    }

    // Right-associative
    if (match(TokenType::Power)) {
        auto right = parse_power();
        if (!right) {
            return nullptr;
        }
        return make_binary_op(ExprOp::Power, std::move(left), std::move(right));
    }

    return left;
}

std::unique_ptr<ExprNode> ExprParser::parse_unary() {
    if (match(TokenType::Plus)) {
        auto operand = parse_unary();
        if (!operand) {
            return nullptr;
        }
        return make_unary_op(ExprOp::UnaryPlus, std::move(operand));
    }

    if (match(TokenType::Minus)) {
        auto operand = parse_unary();
        if (!operand) {
            return nullptr;
        }
        return make_unary_op(ExprOp::UnaryMinus, std::move(operand));
    }

    if (match(TokenType::LogicalNot)) {
        auto operand = parse_unary();
        if (!operand) {
            return nullptr;
        }
        return make_unary_op(ExprOp::LogicalNot, std::move(operand));
    }

    if (match(TokenType::BitwiseNot)) {
        auto operand = parse_unary();
        if (!operand) {
            return nullptr;
        }
        return make_unary_op(ExprOp::BitwiseNot, std::move(operand));
    }

    return parse_primary();
}

std::unique_ptr<ExprNode> ExprParser::parse_primary() {
    if (at_end()) {
        return nullptr;
    }

    const Token& tok = current();

    // Integer literal
    if (tok.is(TokenType::Integer)) {
        ++i_;
        return make_integer(tok.int_value());
    }

    // Current address ($) - always resolved immediately
    if (tok.is(TokenType::Dollar) || tok.is(TokenType::ASMPC)) {
        ++i_;

        if (!section_) {
            throw InvalidDollar();  // Error: $ used without section context
        }

        Opcode* last = section_->last_opcode();
        if (!last) {
            throw InvalidDollar();  // Error: $ used with no opcodes
        }

        return make_dollar(last, section_);
    }

    // Identifier (symbol reference) - always resolved immediately
    if (tok.is(TokenType::Identifier)) {
        ++i_;
        std::string name = tok.text();

        if (!module_) {
            throw UndefinedSymbol(name);  // Error: no module context
        }

        Symbol* symbol = module_->find_symbol(name);
        if (!symbol) {
            // Symbol doesn't exist yet - create it as undefined
            Location loc = line_.location();
            symbol = module_->add_symbol(name, loc);
        }

        return make_symbol(symbol);
    }

    // Parenthesized expression
    if (match(TokenType::LeftParen)) {
        auto expr = parse_ternary();
        if (!expr) {
            return nullptr;
        }

        if (!match(TokenType::RightParen)) {
            return nullptr;
        }

        return expr;
    }

    return nullptr;
}

} // anonymous namespace

//-----------------------------------------------------------------------------
// Expression implementation
//-----------------------------------------------------------------------------

Expression::Expression(std::unique_ptr<ExprNode> root, const Location& location)
    : root_(std::move(root)), location_(location) {
}

Expression::Expression(const Expression& other)
    : root_(other.root_ ? other.root_->clone() : nullptr),
      location_(other.location_),
      token_line_(other.token_line_ ? std::make_unique<TokenLine>
                  (*other.token_line_) : nullptr) {
}

Expression& Expression::operator=(const Expression& other) {
    if (this != &other) {
        root_ = other.root_ ? other.root_->clone() : nullptr;
        location_ = other.location_;
        token_line_ = other.token_line_ ? std::make_unique<TokenLine>
                      (*other.token_line_) : nullptr;
    }
    return *this;
}

bool Expression::parse(const TokenLine& line, size_t& i, Module* module,
                       Section* section) {
    size_t start_i = i;

    ExprParser parser(line, i, module, section);
    auto root = parser.parse();

    if (root) {
        // Create a TokenLine with only the consumed tokens
        TokenLine expr_tokens(line.location());
        for (size_t j = start_i; j < i; ++j) {
            expr_tokens.tokens().push_back(line.tokens()[j]);
        }

        // Update this expression
        root_ = std::move(root);
        location_ = line.location();
        token_line_ = std::make_unique<TokenLine>(expr_tokens);

        return true;
    }

    // Parse failed - i is already reset by parser
    return false;
}

int Expression::evaluate() const {
    if (!root_) {
        throw ExpressionError("Empty expression");
    }

    // Simply delegate to root node - let exceptions propagate
    return root_->evaluate();
}

bool Expression::is_constant() const {
    if (!root_) {
        return false;  // Empty expression is not constant
    }

    return root_->is_constant();
}

const ExprNode* Expression::root() const {
    return root_.get();
}

void Expression::set_root(std::unique_ptr<ExprNode> root) {
    root_ = std::move(root);
}

const Location& Expression::location() const {
    return location_;
}

const TokenLine& Expression::token_line() const {
    static const TokenLine empty_tokens;
    return token_line_ ? *token_line_ : empty_tokens;
}

void Expression::set_tokens(const TokenLine& token_line) {
    token_line_ = std::make_unique<TokenLine>(token_line);
}

bool Expression::empty() const {
    return root_ == nullptr;
}

void Expression::clear() {
    root_.reset();
    location_ = Location();
    token_line_.reset();
}

std::string Expression::to_string() const {
    if (root_) {
        return root_->to_string();
    }
    return "";
}

//-----------------------------------------------------------------------------
// Symbol implementation
//-----------------------------------------------------------------------------

Symbol::Symbol(const std::string& name, const Location& location)
    : name_(name), location_(location) {}

Symbol::Symbol(const std::string& name, const Location& location, int value,
               SymbolType type)
    : name_(name), value_(value), type_(type), location_(location) {}

Symbol::Symbol(const std::string& name, const Location& location,
               Opcode* opcode, int offset, SymbolType type)
    : name_(name), type_(type), location_(location),
      opcode_(opcode), offset_(offset) { }

const std::string& Symbol::name() const {
    return name_;
}

// set_name() removed - name is immutable (key in symbol table)

int Symbol::value() const {
    return value_;
}

void Symbol::set_value(int value) {
    value_ = value;
}

SymbolType Symbol::type() const {
    return type_;
}

void Symbol::set_type(SymbolType type) {
    type_ = type;
}

SymbolScope Symbol::scope() const {
    return scope_;
}

void Symbol::set_scope(SymbolScope scope) {
    scope_ = scope;
}

const Location& Symbol::location() const {
    return location_;
}

void Symbol::set_location(const Location& location) {
    location_ = location;
}

int Symbol::offset() const {
    return offset_;
}

void Symbol::set_offset(int offset) {
    offset_ = offset;
}

const Expression& Symbol::expression() const {
    return expression_;
}

void Symbol::set_expression(const Expression& expr) {
    expression_ = expr;
}

bool Symbol::has_expression() const {
    return !expression_.empty();
}

bool Symbol::is_undefined() const {
    return type_ == SymbolType::Undefined;
}

bool Symbol::is_constant() const {
    return type_ == SymbolType::Constant;
}

bool Symbol::is_address_relative() const {
    return type_ == SymbolType::AddressRelative;
}

bool Symbol::is_computed() const {
    return type_ == SymbolType::Computed;
}

bool Symbol::is_local() const {
    return scope_ == SymbolScope::Local;
}

bool Symbol::is_public() const {
    return scope_ == SymbolScope::Public ||
           (scope_ == SymbolScope::Global && is_defined());
}

bool Symbol::is_extern() const {
    return scope_ == SymbolScope::Extern ||
           (scope_ == SymbolScope::Global && !is_defined());
}

bool Symbol::is_global() const {
    return scope_ == SymbolScope::Global;
}

bool Symbol::is_exported() const {
    return is_public();
}

bool Symbol::is_imported() const {
    return is_extern();
}

bool Symbol::is_defined() const {
    return type_ != SymbolType::Undefined;
}

int Symbol::evaluate() const {
    // Check for recursive evaluation
    if (evaluating_) {
        throw RecursiveEvaluation(name_);
    }

    // Set evaluating flag
    evaluating_ = true;

    // Ensure flag is cleared on exit
    struct EvalGuard {
        bool& flag;
        EvalGuard(bool& f) : flag(f) {}
        ~EvalGuard() {
            flag = false;
        }
    } guard(evaluating_);

    // Handle each symbol type
    switch (type_) {
    case SymbolType::Undefined:
        throw UndefinedSymbol(name_);

    case SymbolType::Constant:
        return value_;

    case SymbolType::AddressRelative:
        if (!opcode_) {
            throw ExpressionError("Address-relative symbol without opcode: " + name_);
        }
        return opcode_->address() + offset_;

    case SymbolType::Computed:
        if (!has_expression()) {
            throw ExpressionError("Computed symbol without expression: " + name_);
        }
        return expression_.evaluate();

    default:
        throw ExpressionError("Unknown symbol type: " + name_);
    }
}

Opcode* Symbol::opcode() const {
    return opcode_;
}

void Symbol::set_opcode(Opcode* opcode) {
    opcode_ = opcode;
}

//-----------------------------------------------------------------------------
// Patch implementation
//-----------------------------------------------------------------------------

Patch::Patch(int offset, PatchRange range, const Expression& expr)
    : offset_(offset), range_(range), expression_(expr) {}

int Patch::offset() const {
    return offset_;
}

void Patch::set_offset(int offset) {
    offset_ = offset;
}

PatchRange Patch::range() const {
    return range_;
}

void Patch::set_range(PatchRange range) {
    range_ = range;
}

const Expression& Patch::expression() const {
    return expression_;
}

void Patch::set_expression(const Expression& expr) {
    expression_ = expr;
}

const Location& Patch::location() const {
    return expression_.location();
}

bool Patch::resolve(std::vector<uint8_t>& bytes, int asmpc, int opcode_size) {
    try {
        int value = evaluate_expression(asmpc, opcode_size);
        patch_bytes(bytes, value);
        return true;
    }
    catch (const ExpressionError&) {
        // Error already reported by expression evaluation
        return false;
    }
}

int Patch::evaluate_expression(int asmpc, int opcode_size) {
    // For JR_OFFSET and JRE_OFFSET, need to compute relative offset
    int value = expression_.evaluate();

    if (range_ == PatchRange::JrOffset || range_ == PatchRange::JreOffset) {
        // Compute relative offset: target - (asmpc + opcode_size)
        value = value - (asmpc + opcode_size);
    }

    return value;
}

void Patch::patch_bytes(std::vector<uint8_t>& bytes, int value) {
    // Helper lambda to patch a byte at offset
    auto patch_byte = [&](int pos, uint8_t byte_value) {
        if (pos >= 0 && static_cast<size_t>(offset_ + pos) < bytes.size()) {
            bytes[offset_ + pos] = byte_value;
        }
    };

    switch (range_) {
    case PatchRange::ByteUnsigned:
        if (value < -128 || value > 255) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) + " out of range for unsigned byte");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        break;

    case PatchRange::ByteSigned:
        if (value < -128 || value > 127) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) + " out of range for signed byte");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        break;

    case PatchRange::HighOffset:
        if ((value & 0xff00) != 0) {
            if ((value & 0xff00) != 0xff00) {
                g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                                 "Value " + int_to_hex(value) + " out of range for high offset");
            }
        }
        patch_byte(0, static_cast<uint8_t>(value & 0xff));
        break;

    case PatchRange::ByteToWordUnsigned:
        if (value < 0 || value > 255) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) + " out of range for unsigned byte to word");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        patch_byte(1, 0);
        break;

    case PatchRange::ByteToWordSigned:
        if (value < -128 || value > 127) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) + " out of range for signed byte to word");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        patch_byte(1, (value < 0 || value > 127) ? 0xff : 0);
        break;

    case PatchRange::ByteToPtr24Unsigned:
        if (value < 0 || value > 255) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) +
                             " out of range for unsigned byte to 24-bit pointer");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        patch_byte(1, 0);
        patch_byte(2, 0);
        break;

    case PatchRange::ByteToPtr24Signed:
        if (value < -128 || value > 127) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) +
                             " out of range for signed byte to 24-bit pointer");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        patch_byte(1, (value < 0 || value > 127) ? 0xff : 0);
        patch_byte(2, (value < 0 || value > 127) ? 0xff : 0);
        break;

    case PatchRange::Ptr24:
        patch_byte(0, static_cast<uint8_t>((value >> 0) & 0xff));
        patch_byte(1, static_cast<uint8_t>((value >> 8) & 0xff));
        patch_byte(2, static_cast<uint8_t>((value >> 16) & 0xff));
        break;

    case PatchRange::Word:
        // Little-endian word
        patch_byte(0, static_cast<uint8_t>((value >> 0) & 0xff));
        patch_byte(1, static_cast<uint8_t>((value >> 8) & 0xff));
        break;

    case PatchRange::WordBigEndian:
        // Big-endian word
        patch_byte(0, static_cast<uint8_t>((value >> 8) & 0xff));
        patch_byte(1, static_cast<uint8_t>((value >> 0) & 0xff));
        break;

    case PatchRange::Dword:
        // Little-endian dword
        patch_byte(0, static_cast<uint8_t>((value >> 0) & 0xff));
        patch_byte(1, static_cast<uint8_t>((value >> 8) & 0xff));
        patch_byte(2, static_cast<uint8_t>((value >> 16) & 0xff));
        patch_byte(3, static_cast<uint8_t>((value >> 24) & 0xff));
        break;

    case PatchRange::JrOffset:
        // Value already adjusted by evaluate_expression()
        if (value < -128 || value > 127) {
            g_errors.error(expression_.location(), ErrorCode::IntegerRange,
                           "JR offset " + int_to_hex(value) + " out of range (-128 to 127)");
        }
        else {
            patch_byte(0, static_cast<uint8_t>(value));
        }
        break;

    case PatchRange::JreOffset:
        // Value already adjusted by evaluate_expression()
        if (value < -0x8000 || value > 0x7FFF) {
            g_errors.error(expression_.location(), ErrorCode::IntegerRange,
                           "JR extended offset " + int_to_hex(value) + " out of range (-32768 to 32767)");
        }
        else {
            // Little-endian word
            patch_byte(0, static_cast<uint8_t>((value >> 0) & 0xff));
            patch_byte(1, static_cast<uint8_t>((value >> 8) & 0xff));
        }
        break;

    case PatchRange::Assignment:
        // Assignment patches don't modify bytes
        break;

    case PatchRange::Undefined:
    default:
        assert(0); // Should not reach here
        break;
    }
}

//-----------------------------------------------------------------------------
// Opcode implementation
//-----------------------------------------------------------------------------

Opcode::Opcode(const Location& location) : location_(location) {}

Opcode::Opcode(const std::vector<uint8_t>& bytes, const Location& location)
    : bytes_(bytes), location_(location) {}

Opcode::Opcode(int address, const std::vector<uint8_t>& bytes,
               const Location& location)
    : address_(address), bytes_(bytes), location_(location) {}

int Opcode::address() const {
    return address_;
}

void Opcode::set_address(int address) {
    address_ = address;
}

const std::vector<uint8_t>& Opcode::bytes() const {
    return bytes_;
}

std::vector<uint8_t>& Opcode::bytes() {
    return bytes_;
}

void Opcode::set_bytes(const std::vector<uint8_t>& bytes) {
    bytes_ = bytes;
}

size_t Opcode::size() const {
    return bytes_.size();
}

void Opcode::clear_bytes() {
    bytes_.clear();
}

void Opcode::add_byte(uint8_t byte) {
    bytes_.push_back(byte);
}

void Opcode::add_bytes(unsigned int value) {
    // Extract bytes from value (up to 4 bytes)
    // Find the first non-zero byte from high to low order
    // Then add that byte and all lower order bytes

    // Break into bytes
    uint8_t byte3 = static_cast<uint8_t>((value >> 24) & 0xFF);
    uint8_t byte2 = static_cast<uint8_t>((value >> 16) & 0xFF);
    uint8_t byte1 = static_cast<uint8_t>((value >> 8) & 0xFF);
    uint8_t byte0 = static_cast<uint8_t>(value & 0xFF);

    // Find first non-zero byte (or start at byte 0 if all are zero)
    if (byte3 != 0) {
        bytes_.push_back(byte3);
        bytes_.push_back(byte2);
        bytes_.push_back(byte1);
        bytes_.push_back(byte0);
    }
    else if (byte2 != 0) {
        bytes_.push_back(byte2);
        bytes_.push_back(byte1);
        bytes_.push_back(byte0);
    }
    else if (byte1 != 0) {
        bytes_.push_back(byte1);
        bytes_.push_back(byte0);
    }
    else {
        bytes_.push_back(byte0);
    }
}

const std::vector<Patch>& Opcode::patches() const {
    return patches_;
}

void Opcode::add_patch(const Patch& patch) {
    patches_.push_back(patch);
}

void Opcode::clear_patches() {
    patches_.clear();
}

bool Opcode::has_patches() const {
    return !patches_.empty();
}

const Location& Opcode::location() const {
    return location_;
}

//-----------------------------------------------------------------------------
// Section implementation
//-----------------------------------------------------------------------------

Section::Section(const std::string& name) : name_(name) {
    // Always start with an empty opcode so last_opcode() never returns nullptr
    opcodes_.push_back(std::make_unique<Opcode>(Location()));
}

const std::string& Section::name() const {
    return name_;
}

void Section::set_name(const std::string& name) {
    name_ = name;
}

int Section::alignment() const {
    return alignment_;
}

void Section::set_alignment(int align) {
    if (align <= 0) {
        align = 1;    // Minimum alignment is 1 (no constraint)
    }
    alignment_ = align;

    // Re-adjust base address to meet new alignment requirement
    base_address_ = align_address(base_address_, alignment_);
}

int Section::base_address() const {
    return base_address_;
}

void Section::set_base_address(int addr) {
    base_address_ = align_address(addr, alignment_);
}

const std::vector<std::unique_ptr<Opcode>>& Section::opcodes() const {
    return opcodes_;
}

Opcode* Section::add_opcode(const Opcode& opcode) {
    opcodes_.push_back(std::make_unique<Opcode>(opcode));
    return opcodes_.back().get();
}

Opcode* Section::last_opcode() {
    // Never returns nullptr - there's always at least one empty opcode
    return opcodes_.back().get();
}

const Opcode* Section::last_opcode() const {
    // Never returns nullptr - there's always at least one empty opcode
    return opcodes_.back().get();
}

void Section::clear_opcodes() {
    opcodes_.clear();
    // Always maintain at least one empty opcode so last_opcode() never returns nullptr
    opcodes_.push_back(std::make_unique<Opcode>(Location()));
}

size_t Section::size() const {
    size_t total = 0;
    for (const auto& opcode : opcodes_) {
        total += opcode->size();
    }
    return total;
}

int Section::pc() const {
    return base_address_ + static_cast<int>(size());
}

void Section::compute_opcodes_addresses() {
    int addr = base_address_;
    for (auto& opcode : opcodes_) {
        opcode->set_address(addr);
        addr += static_cast<int>(opcode->size());
    }
}

int Section::align_address(int addr, int alignment) {
    if (alignment <= 1) {
        return addr;    // No alignment needed
    }

    // Calculate aligned address
    // Formula: ((addr + alignment - 1) / alignment) * alignment
    int remainder = addr % alignment;
    if (remainder == 0) {
        return addr;    // Already aligned
    }

    return addr + (alignment - remainder);
}

//-----------------------------------------------------------------------------
// Module implementation
//-----------------------------------------------------------------------------

Module::Module(const std::string& name, const Location& location)
    : name_(name), location_(location) {
    // Create the default empty-named section
    // (Section constructor already adds an empty opcode)
    sections_.push_back(std::make_unique<Section>(""));
    current_section_ = sections_.back().get();
}

const std::string& Module::name() const {
    return name_;
}

const Location& Module::location() const {
    return location_;
}

Section* Module::current_section() {
    return current_section_;
}

const Section* Module::current_section() const {
    return current_section_;
}

const std::vector<std::unique_ptr<Section>>& Module::sections() const {
    return sections_;
}

Section* Module::add_section(const std::string& name) {
    // Check if section already exists
    Section* existing = find_section(name);
    if (existing) {
        current_section_ = existing;  // Update current section pointer
        return existing;              // Return existing section
    }

    // Add new section (heap-allocated for pointer stability)
    // Section constructor already adds an empty opcode
    sections_.push_back(std::make_unique<Section>(name));
    current_section_ = sections_.back().get();  // Update current section pointer
    return current_section_;
}

Section* Module::find_section(const std::string& name) {
    for (auto& section : sections_) {
        if (section->name() == name) {
            return section.get();
        }
    }
    return nullptr;
}

void Module::clear_sections() {
    sections_.clear();
    // Recreate the default empty-named section
    sections_.push_back(std::make_unique<Section>(""));
    current_section_ = sections_.back().get();
}

const std::unordered_map<std::string, Symbol>& Module::symbols() const {
    return symbols_;
}

Symbol* Module::find_symbol(const std::string& name) {
    auto it = symbols_.find(name);
    if (it != symbols_.end()) {
        return &it->second;
    }
    return nullptr;
}

const Symbol* Module::find_symbol(const std::string& name) const {
    auto it = symbols_.find(name);
    if (it != symbols_.end()) {
        return &it->second;
    }
    return nullptr;
}

bool Module::has_symbol(const std::string& name) const {
    return symbols_.find(name) != symbols_.end();
}

void Module::clear_symbols() {
    symbols_.clear();
}

const std::vector<Location>& Module::get_extern_declarations(
    const std::string& name) const {
    static const std::vector<Location> empty;
    auto it = extern_declarations_.find(name);
    return (it != extern_declarations_.end()) ? it->second : empty;
}

//-----------------------------------------------------------------------------
// Module symbol management
//-----------------------------------------------------------------------------

Symbol* Module::declare_symbol(const std::string& name,
                               const Location& location, SymbolScope scope) {
    // Track extern declaration locations for error reporting
    if (scope == SymbolScope::Extern) {
        extern_declarations_[name].push_back(location);
    }

    // Find or create symbol
    auto it = symbols_.find(name);
    if (it == symbols_.end()) {
        // Create new undefined symbol with requested scope
        symbols_.emplace(name, Symbol(name, location));
        it = symbols_.find(name);
        it->second.set_scope(scope);
        return &it->second;
    }

    Symbol* sym = &it->second;
    SymbolScope current_scope = sym->scope();

    // Same scope - OK (idempotent)
    if (current_scope == scope) {
        return sym;
    }

    // Check for invalid EXTERN declaration of defined symbol (must come early)
    if (scope == SymbolScope::Extern && sym->is_defined()) {
        g_errors.error(location, ErrorCode::SymbolRedefined, name +
                       " (cannot declare defined symbol as EXTERN)");
        return sym;
    }

    // Allow Local to be upgraded to any other scope
    if (current_scope == SymbolScope::Local) {
        sym->set_scope(scope);
        return sym;
    }

    // Allow Global to transition to Public or Extern
    if (current_scope == SymbolScope::Global &&
            (scope == SymbolScope::Public || scope == SymbolScope::Extern)) {
        sym->set_scope(scope);
        return sym;
    }

    // Otherwise, it's a scope conflict
    g_errors.error(location, ErrorCode::SymbolRedefined, name);
    return sym;  // Return existing symbol despite error
}

Symbol* Module::add_symbol(const std::string& name, const Location& location) {
    auto it = symbols_.find(name);

    if (it != symbols_.end()) {
        // Symbol already exists
        Symbol& existing = it->second;

        // Error if symbol is already defined
        if (existing.is_defined()) {
            g_errors.error(location, ErrorCode::SymbolRedefined, name);
            return &existing;
        }

        // Error if trying to define an explicitly EXTERN symbol (not Global)
        if (existing.scope() == SymbolScope::Extern) {
            g_errors.error(location, ErrorCode::SymbolRedefined,
                           name + " (cannot define EXTERN symbol)");
            return &existing;
        }

        // Update location for the definition
        existing.set_location(location);
        return &existing;
    }

    // Symbol doesn't exist - create it
    auto result = symbols_.emplace(name, Symbol(name, location));
    return &result.first->second;
}

Symbol* Module::add_symbol(const std::string& name, const Location& location,
                           int value, SymbolType type) {
    auto it = symbols_.find(name);

    if (it != symbols_.end()) {
        // Symbol already exists
        Symbol& existing = it->second;

        // Error if symbol is already defined
        if (existing.is_defined()) {
            g_errors.error(location, ErrorCode::SymbolRedefined, name);
            return &existing;
        }

        // Error if trying to define an explicitly EXTERN symbol (not Global)
        if (existing.scope() == SymbolScope::Extern) {
            g_errors.error(location, ErrorCode::SymbolRedefined,
                           name + " (cannot define EXTERN symbol)");
            return &existing;
        }

        // Update the symbol with definition
        existing.set_value(value);
        existing.set_type(type);
        existing.set_location(location);

        return &existing;
    }

    // Symbol doesn't exist - create it with definition
    auto result = symbols_.emplace(name, Symbol(name, location, value, type));
    return &result.first->second;
}

//-----------------------------------------------------------------------------
// CompilationUnit implementation
//-----------------------------------------------------------------------------

CompilationUnit::CompilationUnit(const std::string& name,
                                 const Location& location)
    : name_(name), location_(location) {
    // Create the default empty-named module
    add_module("");
}

const std::string& CompilationUnit::name() const {
    return name_;
}

const Location& CompilationUnit::location() const {
    return location_;
}

const std::vector<std::unique_ptr<Module>>& CompilationUnit::modules() const {
    return modules_;
}

Module* CompilationUnit::add_module(const std::string& name) {
    // Check if module already exists
    Module* existing = find_module(name);
    if (existing) {
        current_module_ = existing;  // Update current module pointer
        return existing;              // Return existing module
    }

    // Create new module (heap-allocated for pointer stability)
    auto module = std::make_unique<Module>(name, location_);
    Module* module_ptr = module.get();  // Save pointer before move

    modules_.push_back(std::move(module));

    current_module_ = module_ptr;  // Update current module pointer
    return module_ptr;
}

Module* CompilationUnit::find_module(const std::string& name) {
    for (auto& module : modules_) {
        if (module->name() == name) {
            return module.get();
        }
    }
    return nullptr;
}

const Module* CompilationUnit::find_module(const std::string& name) const {
    for (auto& module : modules_) {
        if (module->name() == name) {
            return module.get();
        }
    }
    return nullptr;
}

Module* CompilationUnit::current_module() {
    return current_module_;
}

const Module* CompilationUnit::current_module() const {
    return current_module_;
}

void CompilationUnit::clear_modules() {
    modules_.clear();
    // Recreate the default empty-named module
    add_module("");
}

//-----------------------------------------------------------------------------
// Library implementation
//-----------------------------------------------------------------------------

Library::Library(const std::string& filename)
    : filename_(filename) {
}

const std::string& Library::filename() const {
    return filename_;
}

const std::unordered_map<std::string, Module*>& Library::public_symbols()
const {
    return public_symbols_;
}

Module* Library::find_public_symbol(const std::string& name) {
    auto it = public_symbols_.find(name);
    if (it != public_symbols_.end()) {
        return it->second;
    }
    return nullptr;
}

const Module* Library::find_public_symbol(const std::string& name) const {
    auto it = public_symbols_.find(name);
    if (it != public_symbols_.end()) {
        return it->second;
    }
    return nullptr;
}

bool Library::has_public_symbol(const std::string& name) const {
    return public_symbols_.find(name) != public_symbols_.end();
}

const std::vector<std::unique_ptr<Module>>& Library::modules() const {
    return modules_;
}

Module* Library::add_module(std::unique_ptr<Module> module) {
    if (!module) {
        return nullptr;
    }

    Module* module_ptr = module.get();
    modules_.push_back(std::move(module));

    // Index all public symbols from this module
    index_module_public_symbols(module_ptr);

    return module_ptr;
}

Module* Library::find_module(const std::string& name) {
    for (auto& module : modules_) {
        if (module->name() == name) {
            return module.get();
        }
    }
    return nullptr;
}

const Module* Library::find_module(const std::string& name) const {
    for (auto& module : modules_) {
        if (module->name() == name) {
            return module.get();
        }
    }
    return nullptr;
}

void Library::clear_modules() {
    modules_.clear();
    public_symbols_.clear();
}

void Library::rebuild_public_symbol_index() {
    public_symbols_.clear();

    // Rebuild index from all modules
    for (auto& module : modules_) {
        index_module_public_symbols(module.get());
    }
}

void Library::index_module_public_symbols(Module* module) {
    if (!module) {
        return;
    }

    // Index all public symbols from this module
    for (const auto& [name, symbol] : module->symbols()) {
        if (symbol.is_public()) {
            // If symbol already exists, keep first occurrence (library order matters)
            if (public_symbols_.find(name) == public_symbols_.end()) {
                public_symbols_[name] = module;
            }
        }
    }
}

size_t Library::module_count() const {
    return modules_.size();
}

size_t Library::public_symbol_count() const {
    return public_symbols_.size();
}

//-----------------------------------------------------------------------------
// Linker implementation
//-----------------------------------------------------------------------------

Linker::Linker() {
}

Module* Linker::add_module(std::unique_ptr<Module> module) {
    if (!module) {
        return nullptr;
    }

    Module* module_ptr = module.get();
    modules_.push_back(std::move(module));

    // Index public symbols from this module
    index_module_public_symbols(module_ptr);

    // Update unresolved externs list
    update_unresolved_externs(module_ptr);

    return module_ptr;
}

void Linker::add_library(Library* library) {
    if (library) {
        libraries_.push_back(library);
    }
}

bool Linker::link_libraries() {
    // Keep trying to resolve symbols until no more progress
    bool progress = true;
    int iteration = 0;
    const int MAX_ITERATIONS = 1000; // Prevent infinite loops

    while (progress && !unresolved_externs_.empty() && iteration < MAX_ITERATIONS) {
        progress = false;
        iteration++;

        // Take a copy of unresolved symbols (map may be modified during iteration)
        std::vector<std::string> symbols_to_resolve;
        for (const auto& [symbol_name, locations] : unresolved_externs_) {
            symbols_to_resolve.push_back(symbol_name);
        }

        // Try to resolve each symbol
        for (const auto& symbol_name : symbols_to_resolve) {
            // Skip if already resolved in a previous iteration
            if (unresolved_externs_.find(symbol_name) == unresolved_externs_.end()) {
                continue;
            }

            Module* defining_module = resolve_from_libraries(symbol_name);
            if (defining_module) {
                progress = true;
                // Symbol is now resolved (removed by resolve_from_libraries updating public_symbols_)
                unresolved_externs_.erase(symbol_name);
            }
        }
    }

    if (iteration >= MAX_ITERATIONS) {
        g_errors.error(Location(), ErrorCode::LinkError,
                       "Maximum link iterations exceeded - possible circular dependencies");
    }

    // Report any remaining unresolved symbols
    for (const auto& [symbol_name, locations] : unresolved_externs_) {
        for (const auto& loc : locations) {
            g_errors.error(loc, ErrorCode::UndefinedSymbol,
                           "Unresolved external symbol: " + symbol_name);
        }
    }

    return unresolved_externs_.empty();
}

const std::vector<std::unique_ptr<Module>>& Linker::modules() const {
    return modules_;
}

const std::unordered_map<std::string, Module*>& Linker::public_symbols() const {
    return public_symbols_;
}

const std::unordered_map<std::string, std::vector<Location>>&
        Linker::unresolved_externs()
const {
    return unresolved_externs_;
}

bool Linker::has_unresolved_symbols() const {
    return !unresolved_externs_.empty();
}

const std::vector<Library*>& Linker::libraries() const {
    return libraries_;
}

void Linker::clear() {
    modules_.clear();
    libraries_.clear();
    public_symbols_.clear();
    unresolved_externs_.clear();
    library_modules_pulled_.clear();
    currently_resolving_.clear();
}

size_t Linker::module_count() const {
    return modules_.size();
}

size_t Linker::public_symbol_count() const {
    return public_symbols_.size();
}

size_t Linker::unresolved_symbol_count() const {
    return unresolved_externs_.size();
}

void Linker::index_module_public_symbols(Module* module) {
    if (!module) {
        return;
    }

    // Index all public symbols from this module
    for (const auto& [name, symbol] : module->symbols()) {
        if (symbol.is_public()) {
            // Check for duplicate public symbols
            auto it = public_symbols_.find(name);
            if (it != public_symbols_.end()) {
                g_errors.error(symbol.location(), ErrorCode::SymbolRedefined,
                               "Duplicate public symbol: " + name +
                               " (first defined in module " + it->second->name() + ")");
            }
            else {
                public_symbols_[name] = module;
            }
        }
    }
}

void Linker::update_unresolved_externs(Module* module) {
    if (!module) {
        return;
    }

    // Process extern symbols from this module
    for (const auto& [name, symbol] : module->symbols()) {
        if (symbol.is_extern()) {
            // Check if this symbol is now defined by a public symbol
            if (public_symbols_.find(name) != public_symbols_.end()) {
                // Symbol is resolved - remove from unresolved list if present
                unresolved_externs_.erase(name);
            }
            else {
                // Symbol is still unresolved
                // Add all declaration locations from this module
                const auto& decl_locs = module->get_extern_declarations(name);
                for (const auto& loc : decl_locs) {
                    unresolved_externs_[name].push_back(loc);
                }
            }
        }
    }

    // Also check if newly public symbols resolve any existing externs
    for (const auto& [name, symbol] : module->symbols()) {
        if (symbol.is_public()) {
            // This public symbol may resolve pending externs
            unresolved_externs_.erase(name);
        }
    }
}

Module* Linker::resolve_from_libraries(const std::string& symbol_name) {
    return resolve_with_cycle_detection(symbol_name, 0);
}

Module* Linker::resolve_with_cycle_detection(const std::string& symbol_name,
        int depth) {
    // Check for excessive recursion depth
    if (depth > MAX_RESOLUTION_DEPTH) {
        g_errors.error(Location(), ErrorCode::LinkError,
                       "Circular dependency detected while resolving symbol: " + symbol_name);
        return nullptr;
    }

    // Check if we're already trying to resolve this symbol (direct cycle)
    if (currently_resolving_.find(symbol_name) != currently_resolving_.end()) {
        g_errors.error(Location(), ErrorCode::LinkError,
                       "Circular dependency detected: symbol " + symbol_name +
                       " depends on itself through library modules");
        return nullptr;
    }

    // Mark this symbol as being resolved
    currently_resolving_.insert(symbol_name);

    // Ensure we remove from currently_resolving_ on exit
    struct ResolveGuard {
        std::set<std::string>& set;
        std::string name;
        ResolveGuard(std::set<std::string>& s, const std::string& n) : set(s),
            name(n) {}
        ~ResolveGuard() {
            set.erase(name);
        }
    } guard(currently_resolving_, symbol_name);

    // Search libraries in order
    for (Library* library : libraries_) {
        Module* defining_module = library->find_public_symbol(symbol_name);
        if (defining_module) {
            // Check if this library module has already been pulled in
            if (library_modules_pulled_.find(defining_module) ==
                    library_modules_pulled_.end()) {
                // Mark module as pulled in
                library_modules_pulled_.insert(defining_module);

                // Index all public symbols from this library module
                index_module_public_symbols(defining_module);

                // Process any extern dependencies of this module recursively
                for (const auto& [name, symbol] : defining_module->symbols()) {
                    if (symbol.is_extern()) {
                        // Check if still unresolved
                        if (public_symbols_.find(name) == public_symbols_.end()) {
                            // Try to resolve recursively
                            resolve_with_cycle_detection(name, depth + 1);
                        }
                    }
                }
            }

            return defining_module;
        }
    }

    return nullptr;
}

