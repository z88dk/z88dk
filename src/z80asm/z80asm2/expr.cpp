//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "expr.h"
#include "lexer.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <cassert>
#include <cstdint>
#include <string>
#include <string_view>

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

//-----------------------------------------------------------------------------
// Expression parse context
//-----------------------------------------------------------------------------

ExprParseContext::ExprParseContext(const std::vector<Token>& toks, size_t& p)
    : tokens(toks), pos(p) {
}

const Token& ExprParseContext::peek() const {
    // to return a reference when out of bounds
    static Token eol_token = Token::end_of_line(SourceLoc());

    if (pos >= tokens.size()) {
        if (tokens.empty()) {
            eol_token.loc = SourceLoc();
        }
        else {
            // point to after last token for better error messages when the expression is exhausted
            eol_token.loc = tokens.back().loc;
            eol_token.loc.column += static_cast<uint16_t>(g_strings.view(tokens.back().text_id).size());
        }

        return eol_token;
    }
    else {
        return tokens[pos];
    }
}

void ExprParseContext::advance() {
    ++pos;
}

bool ExprParseContext::eof() const {
    return pos >= tokens.size();
}

std::string ExprParseContext::prev_token_text() const {
    if (pos > 0 && pos - 1 < tokens.size()) {
        return escape_string(g_strings.view(tokens[pos - 1].text_id));
    }
    return "\"<start of expression>\"";
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

void ConstEvalSem::literal_float(const Token& tok) {
    push(static_cast<int>(tok.value.float_value));
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

void ConstEvalSem::unary(TokenType op, const SourceLoc& ) {
    int v = pop();
    switch (op) {
    case TokenType::Plus:
        push(+v);
        break;
    case TokenType::Minus:
        push(-v);
        break;
    case TokenType::LogicalNot:
        push(!v);
        break;
    case TokenType::BitwiseNot:
        push(~v);
        break;
    default:
        assert(0);
        break;
    }
}

void ConstEvalSem::binary(TokenType op, const SourceLoc& loc) {
    int rhs = pop();
    int lhs = pop();
    switch (op) {
    case TokenType::Plus:
        push(lhs + rhs);
        break;
    case TokenType::Minus:
        push(lhs - rhs);
        break;
    case TokenType::Multiply:
        push(lhs * rhs);
        break;
    case TokenType::Divide:
        if (rhs == 0) {
            g_diag.error(loc, "Division by zero");
            push(0);
        }
        else {
            push(lhs / rhs);
        }
        break;
    case TokenType::Modulo:
        if (rhs == 0) {
            g_diag.error(loc, "Modulo by zero");
            push(0);
        }
        else {
            push(lhs % rhs);
        }
        break;
    case TokenType::Power:
        push(int_pow(lhs, rhs, loc));
        break;
    case TokenType::LeftShift:
        push(lhs << rhs);
        break;
    case TokenType::RightShift:
        push(lhs >> rhs);
        break;
    case TokenType::LT:
        push(lhs < rhs);
        break;
    case TokenType::LE:
        push(lhs <= rhs);
        break;
    case TokenType::GT:
        push(lhs > rhs);
        break;
    case TokenType::GE:
        push(lhs >= rhs);
        break;
    case TokenType::EQ:
        push (lhs == rhs);
        break;
    case TokenType::NE:
        push(lhs != rhs);
        break;
    case TokenType::BitwiseAnd:
        push(lhs & rhs);
        break;
    case TokenType::BitwiseXor:
        push(lhs ^ rhs);
        break;
    case TokenType::BitwiseOr:
        push (lhs | rhs);
        break;
    case TokenType::LogicalAnd:
        push(lhs && rhs);
        break;
    case TokenType::LogicalOr:
        push(lhs || rhs);
        break;
    case TokenType::LogicalXor:
        push((!!lhs) ^ (!!rhs));
        break;
    default:
        assert(0);
        break;
    }
}

void ConstEvalSem::ternary(const SourceLoc&) {
    int false_val = pop();
    int true_val = pop();
    int cond = pop();
    push(cond ? true_val : false_val);
}

void ConstEvalSem::error_expected_operand(ExprParseContext& ctx) const {
    if (silent) {
        return;
    }

    if (ctx.pos > 0 && ctx.pos - 1 < ctx.tokens.size()) {
        // exhausted tokens after an operator
        const Token& prev = ctx.tokens[ctx.pos - 1];
        g_diag.error(prev.loc, "Unterminated expression after "
                     + escape_string(g_strings.view(prev.text_id)));
    }
    else if (ctx.pos < ctx.tokens.size()) {
        // valid token that is not a valid operand
        const Token& cur = ctx.tokens[ctx.pos];
        g_diag.error(cur.loc, "Expected a value, got "
                     + escape_string(g_strings.view(cur.text_id)));
    }
    else if (!ctx.tokens.empty()) {
        // exhausted tokens at the start of the expression
        const Token& first = ctx.tokens[0];
        g_diag.error(first.loc, "Expected a value, got end of expression");
    }
    else {
        // empty token stream
        g_diag.error(SourceLoc(), "Empty expression");
    }

}

void ConstEvalSem::error_missing_rparen(ExprParseContext& ctx) const {
    if (!silent) {
        const Token& prev = ctx.pos > 0 && ctx.pos - 1 < ctx.tokens.size() ?
                            ctx.tokens[ctx.pos - 1] : Token{};
        g_diag.error(prev.loc, "Missing ')' after token "
                     + escape_string(g_strings.view(prev.text_id)));
    }
}

void ConstEvalSem::error_missing_rbracket(ExprParseContext& ctx) const {
    if (!silent) {
        const Token& prev = ctx.pos > 0 && ctx.pos - 1 < ctx.tokens.size() ?
                            ctx.tokens[ctx.pos - 1] : Token{};
        g_diag.error(prev.loc, "Missing ']' after token "
                     + escape_string(g_strings.view(prev.text_id)));
    }
}

void ConstEvalSem::error_missing_colon(ExprParseContext& ctx) const {
    if (!silent) {
        const Token& prev = ctx.pos > 0 && ctx.pos - 1 < ctx.tokens.size() ?
                            ctx.tokens[ctx.pos - 1] : Token{};
        g_diag.error(prev.loc, "Missing ':' after token "
                     + escape_string(g_strings.view(prev.text_id)));
    }
}

void ConstEvalSem::push(int value) {
    stack.push_back(value);
}

int ConstEvalSem::pop() {
    assert(!stack.empty());
    int v = stack.back();
    stack.pop_back();
    return v;
}

//-----------------------------------------------------------------------------
// Constant expression evaluation
//-----------------------------------------------------------------------------

// Internal: shared implementation for both token-based overloads
static bool eval_expr_impl(
    const std::vector<Token>& tokens, size_t& pos,
    const ConstSymbols& sym, int& result, bool silent,
    bool undefined_is_zero) {
    ExprParseContext ctx(tokens, pos);
    ConstEvalSem sem(sym);
    sem.silent = silent;
    sem.undefined_is_zero = undefined_is_zero;

    if (!parse_expr_conditional(ctx, sem)) {
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
    size_t pos = 0;
    if (!eval_expr_impl(tokens, pos, sym, result, silent, undefined_is_zero)) {
        return false;
    }

    if (pos < tokens.size() &&
            tokens[pos].type != TokenType::EndOfLine) {
        if (!silent) {
            g_diag.error(tokens[pos].loc, "Unexpected token after expression: "
                         + escape_string(g_strings.view(tokens[pos].text_id)));
        }
        return false;
    }

    return true;
}

// Strict constant expression: undefined identifiers cause failure
bool eval_const_expr(
    const std::vector<Token>& tokens, size_t& pos,
    const ConstSymbols& sym, int& result, bool silent) {
    return eval_expr_impl(tokens, pos, sym, result, silent, false);
}

bool eval_const_expr(std::string_view expr, const SourceLoc& loc,
                     const ConstSymbols& sym, int& result,
                     bool silent) {
    return eval_expr_text_impl(expr, loc, sym, result, silent, false);
}

// IF condition: undefined identifiers are silently zero
bool eval_if_condition(
    const std::vector<Token>& tokens, size_t& pos,
    const ConstSymbols& sym, int& result, bool silent) {
    return eval_expr_impl(tokens, pos, sym, result, silent, true);
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

bool parse_expression_span(ParseLine& pline) {
    size_t pos0 = pline.pos;

    ExprParseContext ctx(pline.tokens, pline.pos);
    SpanSem sem;
    if (!parse_expr_conditional(ctx, sem)) {
        pline.pos = pos0;
        return false;
    }

    return true;
}

