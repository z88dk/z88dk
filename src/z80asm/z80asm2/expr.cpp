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

void ConstEvalSem::error_expected_operand(const ParseLine& pline) const {
    if (silent) {
        return;
    }

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

void ConstEvalSem::error_missing_rparen(const ParseLine& pline) const {
    if (!silent) {
        const Token& prev = pline.pos > 0 && pline.pos - 1 < pline.tokens.size() ?
                            pline.tokens[pline.pos - 1] : Token{};
        g_diag.error(prev.loc, "Missing ')' after token "
                     + escape_string(g_strings.view(prev.text_id)));
    }
}

void ConstEvalSem::error_missing_rbracket(const ParseLine& pline) const {
    if (!silent) {
        const Token& prev = pline.pos > 0 && pline.pos - 1 < pline.tokens.size() ?
                            pline.tokens[pline.pos - 1] : Token{};
        g_diag.error(prev.loc, "Missing ']' after token "
                     + escape_string(g_strings.view(prev.text_id)));
    }
}

void ConstEvalSem::error_missing_colon(const ParseLine& pline) const {
    if (!silent) {
        const Token& prev = pline.pos > 0 && pline.pos - 1 < pline.tokens.size() ?
                            pline.tokens[pline.pos - 1] : Token{};
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
static bool eval_expr_impl(ParseLine& pline,
                           const ConstSymbols& sym, int& result, bool silent,
                           bool undefined_is_zero) {
    ConstEvalSem sem(sym);
    sem.silent = silent;
    sem.undefined_is_zero = undefined_is_zero;

    if (!parse_expr_conditional(pline, sem)) {
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
            g_diag.error(tokens[pline.pos].loc, "Unexpected token after expression: "
                         + escape_string(g_strings.view(tokens[pline.pos].text_id)));
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

bool parse_expression_span(ParseLine& pline) {
    size_t pos0 = pline.pos;
    SpanSem sem;
    if (!parse_expr_conditional(pline, sem)) {
        pline.pos = pos0;
        return false;
    }

    return true;
}
