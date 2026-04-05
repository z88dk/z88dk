//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "const_expr.h"
#include "diag.h"
#include "lexer.h"
#include "options.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <iostream>
#include <string>
#include <vector>

struct ExprParseContext {
    const std::vector<Token>& tokens;
    size_t& pos;
    const ConstSymbols& sym;
    bool silent;
    bool undefined_is_zero;     // true: IF mode, false: strict const expr
};

static const Token* peek_token(ExprParseContext& ctx) {
    return ctx.pos < ctx.tokens.size() ? &ctx.tokens[ctx.pos] : nullptr;
}

static SourceLoc peek_loc(ExprParseContext& ctx) {
    const Token* token = peek_token(ctx);
    return token != nullptr ? token->loc : SourceLoc();
}

static bool match_token(ExprParseContext& ctx, TokenType type) {
    if (ctx.pos < ctx.tokens.size() && ctx.tokens[ctx.pos].type == type) {
        ctx.pos++;
        return true;
    }
    return false;
}

// Return the text of the previous token for diagnostic messages.
// Falls back to "start of expression" when there is no previous token.
static std::string prev_token_text(ExprParseContext& ctx) {
    if (ctx.pos > 0 && ctx.pos - 1 < ctx.tokens.size()) {
        return escape_string(g_strings.view(ctx.tokens[ctx.pos - 1].text_id));
    }
    return "\"<start of expression>\"";
}

// Report an error for a missing operand. Uses the previous token's context
// when the token stream is exhausted, per project guidelines.
static void error_expected_operand(ExprParseContext& ctx) {
    if (ctx.pos > 0 && ctx.pos >= ctx.tokens.size()) {
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
    else {
        // empty token stream
        g_diag.error(SourceLoc(), "Empty expression");
    }
}

static bool parse_const_expr_conditional(ExprParseContext& ctx, int& result);

static bool parse_const_expr_primary(ExprParseContext& ctx, int& result) {
    const Token* token = peek_token(ctx);
    if (token == nullptr) {
        if (!ctx.silent) {
            error_expected_operand(ctx);
        }
        return false;
    }

    switch (token->type) {
    case TokenType::Integer:
        result = token->value.int_value;
        ctx.pos++;
        return true;

    case TokenType::Float:
        result = static_cast<int>(token->value.float_value);
        ctx.pos++;
        return true;

    case TokenType::Identifier: {
        const ConstSymbol* s = ctx.sym.get(token->text_id);
        if (s != nullptr) {
            result = s->value;
        }
        else if (ctx.undefined_is_zero) {
            // IF mode: undefined identifiers are silently zero
            result = 0;
        }
        else {
            if (!ctx.silent) {
                g_diag.error(token->loc, "Undefined constant: " +
                             g_strings.to_string(token->text_id));
            }
            result = 0;
            ctx.pos++;
            return false;
        }
        ctx.pos++;
        return true;
    }

    case TokenType::Dollar:
    case TokenType::ASMPC:
        if (!ctx.silent) {
            g_diag.error(token->loc,
                         "ASMPC is not allowed in a constant expression");
        }
        result = 0;
        ctx.pos++;
        return false;

    case TokenType::LeftParen: {
        ctx.pos++;
        if (!parse_const_expr_conditional(ctx, result)) {
            return false;
        }
        if (!match_token(ctx, TokenType::RightParen)) {
            if (!ctx.silent) {
                g_diag.error(peek_loc(ctx), "Missing ')' after token "
                             + prev_token_text(ctx));
            }
            return false;
        }
        return true;
    }

    case TokenType::LeftBracket: {
        ctx.pos++;
        if (!parse_const_expr_conditional(ctx, result)) {
            return false;
        }
        if (!match_token(ctx, TokenType::RightBracket)) {
            if (!ctx.silent) {
                g_diag.error(peek_loc(ctx), "Missing ']' after token "
                             + prev_token_text(ctx));
            }
            return false;
        }
        return true;
    }

    default:
        if (!ctx.silent) {
            error_expected_operand(ctx);
        }
        return false;
    }
}

static bool parse_const_expr_unary(ExprParseContext& ctx, int& result) {
    const Token* token = peek_token(ctx);
    if (token == nullptr) {
        if (!ctx.silent) {
            error_expected_operand(ctx);
        }
        return false;
    }

    switch (token->type) {
    case TokenType::Plus:
        ctx.pos++;
        return parse_const_expr_unary(ctx, result);

    case TokenType::Minus:
        ctx.pos++;
        if (!parse_const_expr_unary(ctx, result)) {
            return false;
        }
        result = -result;
        return true;

    case TokenType::LogicalNot:
        ctx.pos++;
        if (!parse_const_expr_unary(ctx, result)) {
            return false;
        }
        result = !result;
        return true;

    case TokenType::BitwiseNot:
        ctx.pos++;
        if (!parse_const_expr_unary(ctx, result)) {
            return false;
        }
        result = ~result;
        return true;

    default:
        return parse_const_expr_primary(ctx, result);
    }
}

static bool parse_const_expr_power(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_unary(ctx, result)) {
        return false;
    }

    if (match_token(ctx, TokenType::Power)) {
        int rhs = 0;
        if (!parse_const_expr_power(ctx, rhs)) {
            return false;
        }
        result = int_pow(result, rhs, peek_loc(ctx));
    }

    return true;
}

static bool parse_const_expr_multiplicative(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_power(ctx, result)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(ctx, TokenType::Multiply)) {
            op = TokenType::Multiply;
        }
        else if (match_token(ctx, TokenType::Divide)) {
            op = TokenType::Divide;
        }
        else if (match_token(ctx, TokenType::Modulo)) {
            op = TokenType::Modulo;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_power(ctx, rhs)) {
            return false;
        }

        switch (op) {
        case TokenType::Multiply:
            result *= rhs;
            break;
        case TokenType::Divide:
            if (rhs == 0) {
                g_diag.error(peek_loc(ctx), "Division by zero");
                result = 0;
            }
            else {
                result /= rhs;
            }
            break;
        case TokenType::Modulo:
            if (rhs == 0) {
                g_diag.error(peek_loc(ctx), "Modulo by zero");
                result = 0;
            }
            else {
                result %= rhs;
            }
            break;
        default:
            break;
        }
    }
}

static bool parse_const_expr_additive(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_multiplicative(ctx, result)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(ctx, TokenType::Plus)) {
            op = TokenType::Plus;
        }
        else if (match_token(ctx, TokenType::Minus)) {
            op = TokenType::Minus;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_multiplicative(ctx, rhs)) {
            return false;
        }

        if (op == TokenType::Plus) {
            result += rhs;
        }
        else {
            result -= rhs;
        }
    }
}

static bool parse_const_expr_shift(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_additive(ctx, result)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(ctx, TokenType::LeftShift)) {
            op = TokenType::LeftShift;
        }
        else if (match_token(ctx, TokenType::RightShift)) {
            op = TokenType::RightShift;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_additive(ctx, rhs)) {
            return false;
        }

        if (op == TokenType::LeftShift) {
            result <<= rhs;
        }
        else {
            result >>= rhs;
        }
    }
}

static bool parse_const_expr_relational(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_shift(ctx, result)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(ctx, TokenType::LT)) {
            op = TokenType::LT;
        }
        else if (match_token(ctx, TokenType::LE)) {
            op = TokenType::LE;
        }
        else if (match_token(ctx, TokenType::GT)) {
            op = TokenType::GT;
        }
        else if (match_token(ctx, TokenType::GE)) {
            op = TokenType::GE;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_shift(ctx, rhs)) {
            return false;
        }

        switch (op) {
        case TokenType::LT:
            result = result < rhs;
            break;
        case TokenType::LE:
            result = result <= rhs;
            break;
        case TokenType::GT:
            result = result > rhs;
            break;
        case TokenType::GE:
            result = result >= rhs;
            break;
        default:
            break;
        }
    }
}

static bool parse_const_expr_equality(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_relational(ctx, result)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(ctx, TokenType::EQ)) {
            op = TokenType::EQ;
        }
        else if (match_token(ctx, TokenType::NE)) {
            op = TokenType::NE;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_relational(ctx, rhs)) {
            return false;
        }

        if (op == TokenType::EQ) {
            result = result == rhs;
        }
        else {
            result = result != rhs;
        }
    }
}

static bool parse_const_expr_bitwise_and(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_equality(ctx, result)) {
        return false;
    }

    while (match_token(ctx, TokenType::BitwiseAnd)) {
        int rhs = 0;
        if (!parse_const_expr_equality(ctx, rhs)) {
            return false;
        }
        result &= rhs;
    }

    return true;
}

static bool parse_const_expr_bitwise_xor(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_bitwise_and(ctx, result)) {
        return false;
    }

    while (match_token(ctx, TokenType::BitwiseXor)) {
        int rhs = 0;
        if (!parse_const_expr_bitwise_and(ctx, rhs)) {
            return false;
        }
        result ^= rhs;
    }

    return true;
}

static bool parse_const_expr_bitwise_or(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_bitwise_xor(ctx, result)) {
        return false;
    }

    while (match_token(ctx, TokenType::BitwiseOr)) {
        int rhs = 0;
        if (!parse_const_expr_bitwise_xor(ctx, rhs)) {
            return false;
        }
        result |= rhs;
    }

    return true;
}

static bool parse_const_expr_logical_and(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_bitwise_or(ctx, result)) {
        return false;
    }

    while (match_token(ctx, TokenType::LogicalAnd)) {
        int rhs = 0;
        if (!parse_const_expr_bitwise_or(ctx, rhs)) {
            return false;
        }
        result = result && rhs;
    }

    return true;
}

static bool parse_const_expr_logical_xor(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_logical_and(ctx, result)) {
        return false;
    }

    while (match_token(ctx, TokenType::LogicalXor)) {
        int rhs = 0;
        if (!parse_const_expr_logical_and(ctx, rhs)) {
            return false;
        }
        result = (!!result) ^ (!!rhs);
    }

    return true;
}

static bool parse_const_expr_logical_or(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_logical_xor(ctx, result)) {
        return false;
    }

    while (match_token(ctx, TokenType::LogicalOr)) {
        int rhs = 0;
        if (!parse_const_expr_logical_xor(ctx, rhs)) {
            return false;
        }
        result = result || rhs;
    }

    return true;
}

static bool parse_const_expr_conditional(ExprParseContext& ctx, int& result) {
    if (!parse_const_expr_logical_or(ctx, result)) {
        return false;
    }

    if (!match_token(ctx, TokenType::Question)) {
        return true;
    }

    int true_value = 0;
    if (!parse_const_expr_conditional(ctx, true_value)) {
        return false;
    }

    if (!match_token(ctx, TokenType::Colon)) {
        if (!ctx.silent) {
            g_diag.error(peek_loc(ctx), "Missing ':' in ternary expression after token "
                         + prev_token_text(ctx));
        }
        return false;
    }

    int false_value = 0;
    if (!parse_const_expr_conditional(ctx, false_value)) {
        return false;
    }

    result = result ? true_value : false_value;
    return true;
}

// Internal: shared implementation for both token-based overloads
static bool eval_expr_impl(
    const std::vector<Token>& tokens, size_t& pos,
    const ConstSymbols& sym, int& result, bool silent,
    bool undefined_is_zero) {
    ExprParseContext ctx{ tokens, pos, sym, silent, undefined_is_zero };
    return parse_const_expr_conditional(ctx, result);
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
        ExprParseContext ctx{ tokens, pos, sym, silent, undefined_is_zero };
        g_diag.error(tokens[pos].loc, "Operator expected after token "
                     + prev_token_text(ctx)
                     + ", got "
                     + escape_string(g_strings.view(tokens[pos].text_id)));
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
