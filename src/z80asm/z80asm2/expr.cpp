//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "expr.h"
#include "ir.h"
#include "lexer.h"
#include "lexer_tokens.h"
#include "release_assert.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <memory>
#include <string>
#include <string_view>
#include <utility>

int int_pow(int base, int exp, const SourceLoc& loc) {
    if (exp < 0) {
        g_diag.error(loc, "Negative exponent in integer is not defined");
        return 0;
    }

    if (base == 0 && exp == 0) {
        g_diag.error(loc, "Zero raised to the power of zero is not defined");
        return 1;   // return something nonzero to avoid cascading errors
    }

    int result = 1;
    while (exp > 0) {
        result *= base;
        exp--;
    }
    return result;
}

int int_unary(TokenType op, int arg, const SourceLoc&, bool) {
    switch (op) {
    case TokenType::Plus:
        return +arg;
    case TokenType::Minus:
        return -arg;
    case TokenType::LogicalNot:
        return !arg;
    case TokenType::BitwiseNot:
        return ~arg;
    default:
        release_assert(0);
        return 0;
    }
}

int int_binary(TokenType op, int lhs, int rhs, const SourceLoc& loc,
               bool silent) {
    switch (op) {
    case TokenType::Plus:
        return lhs + rhs;
    case TokenType::Minus:
        return lhs - rhs;
    case TokenType::Multiply:
        return lhs * rhs;
    case TokenType::Divide:
        if (rhs == 0) {
            if (!silent) {
                g_diag.error(loc, "Division by zero");
            }
            return 0;
        }
        else {
            return lhs / rhs;
        }
    case TokenType::Modulo:
        if (rhs == 0) {
            if (!silent) {
                g_diag.error(loc, "Modulo by zero");
            }
            return 0;
        }
        else {
            return lhs % rhs;
        }
    case TokenType::Power:
        return int_pow(lhs, rhs, loc);
    case TokenType::LeftShift:
        return lhs << rhs;
    case TokenType::RightShift:
        return lhs >> rhs;
    case TokenType::LT:
        return lhs < rhs;
    case TokenType::LE:
        return lhs <= rhs;
    case TokenType::GT:
        return lhs > rhs;
    case TokenType::GE:
        return lhs >= rhs;
    case TokenType::EQ:
        return lhs == rhs;
    case TokenType::NE:
        return lhs != rhs;
    case TokenType::BitwiseAnd:
        return lhs & rhs;
    case TokenType::BitwiseXor:
        return lhs ^ rhs;
    case TokenType::BitwiseOr:
        return lhs | rhs;
    case TokenType::LogicalAnd:
        return lhs && rhs;
    case TokenType::LogicalOr:
        return lhs || rhs;
    case TokenType::LogicalXor:
        return (!!lhs) ^ (!!rhs);
    default:
        release_assert(0);
        return 0;
    }
}

int int_ternary(int cond, int true_value, int false_value,
                const SourceLoc&, bool ) {
    return cond ? true_value : false_value;
}

int int_call_unary(Keyword kw, int arg, const SourceLoc& loc, bool silent) {
    switch (kw) {
    case Keyword::MEM:
        if (!silent && arg < 0) {
            g_diag.warning(loc, "Integer range: " + int_to_hex(arg));
        }
        return arg;
    case Keyword::SIGNED8:
        if (!silent && (arg < -128 || arg > 127)) {
            g_diag.warning(loc, "Integer range: " + int_to_hex(arg));
        }
        return arg;
    case Keyword::SIGNED16:
        if (!silent && (arg < -32768 || arg > 32767)) {
            g_diag.warning(loc, "Integer range: " + int_to_hex(arg));
        }
        return arg;
    case Keyword::UNSIGNED8:
        if (!silent && (arg < 0 || arg > 255)) {
            g_diag.warning(loc, "Integer range: " + int_to_hex(arg));
        }
        return arg;
    case Keyword::UNSIGNED16:
        if (!silent && (arg < 0 || arg > 65535)) {
            g_diag.warning(loc, "Integer range: " + int_to_hex(arg));
        }
        return arg;
    default:
        release_assert(0);
        return arg;
    }
}

//-----------------------------------------------------------------------------
// Pluggable expression parsing - Pratt parser
//-----------------------------------------------------------------------------

OpInfo infix_table(TokenType t, bool restricted) {
    switch (t) {
    case TokenType::Power:
        return {BP_POWER, BP_POWER}; // right-assoc

    case TokenType::Multiply:
    case TokenType::Divide:
    case TokenType::Modulo:
        return {BP_MULTIPLICATIVE, BP_MULTIPLICATIVE + 1};

    case TokenType::Plus:
    case TokenType::Minus:
        return {BP_ADDITIVE, BP_ADDITIVE + 1};

    case TokenType::LeftShift:
    case TokenType::RightShift:
        return {BP_SHIFT, BP_SHIFT + 1};

    case TokenType::LT:
    case TokenType::LE:
    case TokenType::GT:
    case TokenType::GE:
        if (restricted)
            return { BP_SENTINEL, BP_SENTINEL }; // not allowed in restricted mode
        else
            return { BP_RELATIONAL, BP_RELATIONAL + 1 };

    case TokenType::EQ:
    case TokenType::NE:
        if (restricted)
            return { BP_SENTINEL, BP_SENTINEL }; // not allowed in restricted mode
        else
            return {BP_EQUALITY, BP_EQUALITY + 1};

    case TokenType::BitwiseAnd:
        return {BP_BITWISE_AND, BP_BITWISE_AND + 1};
    case TokenType::BitwiseXor:
        return {BP_BITWISE_XOR, BP_BITWISE_XOR + 1};
    case TokenType::BitwiseOr:
        return {BP_BITWISE_OR,  BP_BITWISE_OR + 1};

    case TokenType::LogicalAnd:
        if (restricted)
            return { BP_SENTINEL, BP_SENTINEL }; // not allowed in restricted mode
        else
            return {BP_LOGICAL_AND, BP_LOGICAL_AND + 1};
    case TokenType::LogicalXor:
        if (restricted)
            return { BP_SENTINEL, BP_SENTINEL }; // not allowed in restricted mode
        else
            return {BP_LOGICAL_XOR, BP_LOGICAL_XOR + 1};
    case TokenType::LogicalOr:
        if (restricted)
            return { BP_SENTINEL, BP_SENTINEL }; // not allowed in restricted mode
        else
            return {BP_LOGICAL_OR,  BP_LOGICAL_OR + 1};

    case TokenType::Question:
        return {5, 4}; // special: ternary

    default:
        return {BP_SENTINEL, BP_SENTINEL}; // sentinel for non-operators
    }
}

//-----------------------------------------------------------------------------
// Semantic context for constant expression evaluation
//-----------------------------------------------------------------------------

ConstEvalSem::ConstEvalSem(const ConstSymbols& s)
    : sym(s) {
}

int ConstEvalSem::result() const {
    return stack.empty() ? 0 : stack.back();
}

void ConstEvalSem::literal_integer(const Token& tok) {
    push(tok.value.int_value);
}

bool ConstEvalSem::literal_asmpc(const Token& tok) {
    if (!silent) {
        g_diag.error(tok.loc,
                     "ASMPC is not allowed in a constant expression");
    }
    push(0);
    return false;
}

bool ConstEvalSem::symbol(const Token& tok) {
    const ConstSymbol* s = sym.get(tok.text_id);
    if (s != nullptr) {
        push(s->value);
        return true;
    }
    else if (undefined_is_zero) {
        // IF mode: undefined identifiers are silently zero
        push(0);
        return true;
    }
    else {
        if (!silent) {
            g_diag.error(tok.loc, "Undefined constant: " +
                         g_strings.to_string(tok.text_id));
        }
        push(0);
        return false;
    }
}

bool ConstEvalSem::local_label(const Token& tok) {
    if (!silent) {
        g_diag.error(tok.loc, "Local labels are not allowed in a constant expression");
    }
    push(0);
    return false;
}

void ConstEvalSem::unary(TokenType op, const SourceLoc& loc) {
    int arg = pop();
    int result = int_unary(op, arg, loc, /*silent=*/false);
    push(result);
}

void ConstEvalSem::binary(TokenType op, const SourceLoc& loc) {
    int rhs = pop();
    int lhs = pop();
    int result = int_binary(op, lhs, rhs, loc, /*silent=*/false);
    push(result);
}

void ConstEvalSem::ternary(const SourceLoc& loc) {
    int false_val = pop();
    int true_val = pop();
    int cond = pop();
    int result = int_ternary(cond, true_val, false_val, loc, /*silent=*/false);
    push(result);
}

static void error_expected_operand(const ParseLine& pline) {
    if (pline.pos > 0 && pline.pos - 1 < pline.tokens.size()) {
        // exhausted tokens after an operator
        const Token& prev = pline.tokens[pline.pos - 1];
        g_diag.error(prev.loc, "Unterminated expression after "
                     + escape_string(g_strings.view(prev.text_id)));
    }
    else if (pline.pos < pline.tokens.size()) {
        // valid token that is not a valid operand
        const Token& cur = pline.tokens[pline.pos];
        g_diag.error(cur.loc, "Expected a value, got "
                     + escape_string(g_strings.view(cur.text_id)));
    }
    else if (!pline.tokens.empty()) {
        // exhausted tokens at the start of the expression
        const Token& first = pline.tokens[0];
        g_diag.error(first.loc, "Expected a value, got end of expression");
    }
    else {
        // empty token stream
        g_diag.error(SourceLoc(), "Empty expression");
    }
}

static void error_missing_lparen(const ParseLine& pline) {
    const Token& prev = pline.pos > 0 && pline.pos - 1 < pline.tokens.size() ?
                        pline.tokens[pline.pos - 1] : Token{};
    g_diag.error(prev.loc, "Missing '(' after token "
                 + escape_string(g_strings.view(prev.text_id)));
}

static void error_missing_rparen(const ParseLine& pline) {
    const Token& prev = pline.pos > 0 && pline.pos - 1 < pline.tokens.size() ?
                        pline.tokens[pline.pos - 1] : Token{};
    g_diag.error(prev.loc, "Missing ')' after token "
                 + escape_string(g_strings.view(prev.text_id)));
}

static void error_missing_rbracket(const ParseLine& pline) {
    const Token& prev = pline.pos > 0 && pline.pos - 1 < pline.tokens.size() ?
                        pline.tokens[pline.pos - 1] : Token{};
    g_diag.error(prev.loc, "Missing ']' after token "
                 + escape_string(g_strings.view(prev.text_id)));
}

static void error_missing_colon(const ParseLine& pline) {
    const Token& prev = pline.pos > 0 && pline.pos - 1 < pline.tokens.size() ?
                        pline.tokens[pline.pos - 1] : Token{};
    g_diag.error(prev.loc, "Missing ':' after token "
                 + escape_string(g_strings.view(prev.text_id)));
}

void ConstEvalSem::error_expected_operand(const ParseLine& pline) const {
    if (!silent) {
        ::error_expected_operand(pline);
    }
}

void ConstEvalSem::error_missing_lparen(const ParseLine& pline) const {
    if (!silent) {
        ::error_missing_lparen(pline);
    }
}

void ConstEvalSem::error_missing_rparen(const ParseLine& pline) const {
    if (!silent) {
        ::error_missing_rparen(pline);
    }
}

void ConstEvalSem::error_missing_rbracket(const ParseLine& pline) const {
    if (!silent) {
        ::error_missing_rbracket(pline);
    }
}

void ConstEvalSem::error_missing_colon(const ParseLine& pline) const {
    if (!silent) {
        ::error_missing_colon(pline);
    }
}

void ConstEvalSem::push(int value) {
    stack.push_back(value);
}

int ConstEvalSem::pop() {
    release_assert(!stack.empty());
    int v = stack.back();
    stack.pop_back();
    return v;
}

//-----------------------------------------------------------------------------
// Constant expression evaluation
//-----------------------------------------------------------------------------

// Internal: shared implementation for both token-based overloads
static bool eval_expr_impl(ParseLine& pline,
                           const ConstSymbols& sym, int& result, bool silent,
                           bool undefined_is_zero) {
    ConstEvalSem sem(sym);
    sem.silent = silent;
    sem.undefined_is_zero = undefined_is_zero;

    if (pline.eol()) {
        if (!silent) {
            pline.error("Expression expected");
        }
        return false;
    }

    ParseStatus status = ParseStatus::Unknown;
    if (!parse_full_expr(pline, sem, status)) {
        return false;
    }

    result = sem.result();
    return true;
}

// Internal: shared implementation for both string-based overloads
static bool eval_expr_text_impl(
    std::string_view expr, const SourceLoc& loc,
    const ConstSymbols& sym, int& result, bool silent,
    bool undefined_is_zero) {
    std::vector<Token> tokens = tokenize_text(expr, loc);
    ParseLine pline(tokens);
    if (!eval_expr_impl(pline, sym, result, silent, undefined_is_zero)) {
        return false;
    }

    if (pline.pos < tokens.size() &&
            tokens[pline.pos].type != TokenType::EndOfLine) {
        if (!silent) {
            g_diag.error(tokens[pline.pos].loc, "Unexpected token after expression: " +
                         escape_string(g_strings.view(tokens[pline.pos].text_id)));
        }
        return false;
    }

    return true;
}

// Strict constant expression: undefined identifiers cause failure
bool eval_const_expr(ParseLine& pline,
                     const ConstSymbols& sym, int& result, bool silent) {
    return eval_expr_impl(pline, sym, result, silent, false);
}

bool eval_const_expr(std::string_view expr, const SourceLoc& loc,
                     const ConstSymbols& sym, int& result,
                     bool silent) {
    return eval_expr_text_impl(expr, loc, sym, result, silent, false);
}

// IF condition: undefined identifiers are silently zero
bool eval_if_condition(ParseLine& pline,
                       const ConstSymbols& sym, int& result, bool silent) {
    return eval_expr_impl(pline, sym, result, silent, true);
}

bool eval_if_condition(std::string_view expr, const SourceLoc& loc,
                       const ConstSymbols& sym, int& result,
                       bool silent) {
    return eval_expr_text_impl(expr, loc, sym, result, silent, true);
}

//-----------------------------------------------------------------------------
// Recognizer of expression spans
//-----------------------------------------------------------------------------

int SpanSem::result() const {
    return 0;
}

bool SpanSem::literal_asmpc(const Token&) {
    return true;
}

bool SpanSem::symbol(const Token&) {
    return true;
}

bool SpanSem::local_label(const Token&) {
    return true;
}

bool parse_expr_span(ParseLine& pline) {
    size_t pos0 = pline.pos;
    SpanSem sem;
    ParseStatus status = ParseStatus::Unknown;
    if (!parse_full_expr(pline, sem, status)) {
        pline.pos = pos0;
        return false;
    }

    return true;
}

//-----------------------------------------------------------------------------
// Semantic context for AST builder expression parsing
//-----------------------------------------------------------------------------

std::unique_ptr<Expr> ExprSem::result() {
    return std::move(stack.back());
}

void ExprSem::literal_integer(const Token& tok) {
    stack.push_back(std::make_unique<ExprLiteralInt>(tok.value.int_value, tok.loc));
}

bool ExprSem::literal_asmpc(const Token& tok) {
    stack.push_back(std::make_unique<ExprLiteralAsmpc>(tok.loc));
    return true;
}

bool ExprSem::symbol(const Token& tok) {
    stack.push_back(std::make_unique<ExprSymbol>(tok.text_id, tok.loc));
    return true;
}

bool ExprSem::local_label(const Token& tok) {
    stack.push_back(std::make_unique<ExprLocalLabel>(tok.text_id,
                    tok.value.label_at_pos, tok.loc));
    return true;
}

void ExprSem::unary(TokenType op, const SourceLoc& loc) {
    auto rhs = pop();
    stack.push_back(std::make_unique<ExprUnary>(op, std::move(rhs), loc));
}

void ExprSem::binary(TokenType op, const SourceLoc& loc) {
    auto rhs = pop();
    auto lhs = pop();
    stack.push_back(std::make_unique<ExprBinary>(op, std::move(lhs), std::move(rhs),
                    loc));
}

void ExprSem::ternary(const SourceLoc& loc) {
    auto e = pop();
    auto t = pop();
    auto c = pop();
    stack.push_back(std::make_unique<ExprTernary>(std::move(c), std::move(t),
                    std::move(e), loc));
}

void ExprSem::call_unary(Keyword keyword, const SourceLoc& loc) {
    auto arg = pop();
    stack.push_back(std::make_unique<ExprCallUnary>(keyword, std::move(arg), loc));
}

void ExprSem::error_expected_operand(const ParseLine& pline) const {
    ::error_expected_operand(pline);
}

void ExprSem::error_missing_lparen(const ParseLine& pline) const {
    ::error_missing_lparen(pline);
}

void ExprSem::error_missing_rparen(const ParseLine& pline) const {
    ::error_missing_rparen(pline);
}

void ExprSem::error_missing_rbracket(const ParseLine& pline) const {
    ::error_missing_rbracket(pline);
}

void ExprSem::error_missing_colon(const ParseLine& pline) const {
    ::error_missing_colon(pline);
}

std::unique_ptr<Expr> parse_expr_ast(ParseLine& pline,
                                     ParseStatus& status) {
    size_t expr_start = pline.pos;
    ExprSem sem;
    if (!parse_full_expr(pline, sem, status)) {
        return nullptr; // error already reported
    }
    size_t expr_end = pline.pos;

    std::unique_ptr<Expr> expr = sem.result();
    expr->tokens.insert(expr->tokens.end(),
                        pline.tokens.begin() + expr_start,
                        pline.tokens.begin() + expr_end);

    return expr;
}
