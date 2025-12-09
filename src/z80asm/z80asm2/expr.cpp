//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "expr.h"
#include "module.h"
#include "section.h"
#include "symbols.h"

//-----------------------------------------------------------------------------
// integer power helper (fast exponentiation). negative exponent -> 0
//-----------------------------------------------------------------------------
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
        : opcode_(opcode), section_(section) {
    }

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
        : op_(op), operand_(std::move(operand)) {
    }

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
        : op_(op), left_(std::move(left)), right_(std::move(right)) {
    }

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
          false_expr_(std::move(false_expr)) {
    }

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
        : line_(line), i_(i), start_i_(i), module_(module), section_(section) {
    }

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
    // If tokens were collected during parsing, return the exact tokenized text
    if (token_line_ && !token_line_->tokens().empty()) {
        return token_line_->to_string();
    }

    // Fallback to reconstructing from the AST when no parsed tokens are available
    if (root_) {
        return root_->to_string();
    }
    return "";
}

