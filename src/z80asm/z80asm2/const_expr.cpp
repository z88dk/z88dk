//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "const_expr.h"
#include "errors.h"
#include "lexer.h"
#include "options.h"
#include "source_loc.h"
#include "string_interner.h"
#include "utils.h"
#include <iostream>
#include <string>
#include <vector>


static const Token* peek_token(const std::vector<Token>& tokens, uint32_t pos) {
    return pos < tokens.size() ? &tokens[pos] : nullptr;
}

static SourceLoc peek_loc(const std::vector<Token>& tokens, uint32_t pos) {
    const Token* token = peek_token(tokens, pos);
    return token != nullptr ? token->loc : SourceLoc();
}

static bool match_token(const std::vector<Token>& tokens, uint32_t& pos, TokenType type) {
    if (pos < tokens.size() && tokens[pos].type == type) {
        pos++;
        return true;
    }
    return false;
}

static bool parse_const_expr_conditional(const std::vector<Token>& tokens, uint32_t& pos,
        const ConstSymbols& sym, int& result, bool silent);

static bool parse_const_expr_primary(const std::vector<Token>& tokens, uint32_t& pos,
                                     const ConstSymbols& sym, int& result, bool silent) {
    const Token* token = peek_token(tokens, pos);
    if (token == nullptr) {
        error(peek_loc(tokens, pos), "Constant expression expected");
        return false;
    }

    switch (token->type) {
    case TokenType::Integer:
        result = token->value.int_value;
        pos++;
        return true;

    case TokenType::Float:
        result = static_cast<int>(token->value.float_value);
        pos++;
        return true;

    case TokenType::Identifier: {
        const ConstSymbol* s = sym.get(token->text_id);
        if (s != nullptr) {
            result = s->value;
        }
        else {
            if (!silent) {
                error(token->loc, "Undefined constant: " + g_strings.to_string(token->text_id));
            }
            result = 0;
        }
        pos++;
        return true;
    }

    case TokenType::ASMPC:
        error(token->loc, "ASMPC is not allowed in a constant expression");
        result = 0;
        pos++;
        return true;

    case TokenType::LeftParen: {
        pos++;
        if (!parse_const_expr_conditional(tokens, pos, sym, result, silent)) {
            return false;
        }
        if (!match_token(tokens, pos, TokenType::RightParen)) {
            error(peek_loc(tokens, pos), "Missing ')'");
            return false;
        }
        return true;
    }

    case TokenType::LeftBracket: {
        pos++;
        if (!parse_const_expr_conditional(tokens, pos, sym, result, silent)) {
            return false;
        }
        if (!match_token(tokens, pos, TokenType::RightBracket)) {
            error(peek_loc(tokens, pos), "Missing ']'");
            return false;
        }
        return true;
    }

    default:
        error(token->loc, "Constant expression expected");
        return false;
    }
}

static bool parse_const_expr_unary(const std::vector<Token>& tokens, uint32_t& pos,
                                   const ConstSymbols& sym, int& result, bool silent) {
    const Token* token = peek_token(tokens, pos);
    if (token == nullptr) {
        error(peek_loc(tokens, pos), "Constant expression expected");
        return false;
    }

    switch (token->type) {
    case TokenType::Plus:
        pos++;
        return parse_const_expr_unary(tokens, pos, sym, result, silent);

    case TokenType::Minus:
        pos++;
        if (!parse_const_expr_unary(tokens, pos, sym, result, silent)) {
            return false;
        }
        result = -result;
        return true;

    case TokenType::LogicalNot:
        pos++;
        if (!parse_const_expr_unary(tokens, pos, sym, result, silent)) {
            return false;
        }
        result = !result;
        return true;

    case TokenType::BitwiseNot:
        pos++;
        if (!parse_const_expr_unary(tokens, pos, sym, result, silent)) {
            return false;
        }
        result = ~result;
        return true;

    default:
        return parse_const_expr_primary(tokens, pos, sym, result, silent);
    }
}

static bool parse_const_expr_power(const std::vector<Token>& tokens, uint32_t& pos,
                                   const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_unary(tokens, pos, sym, result, silent)) {
        return false;
    }

    if (match_token(tokens, pos, TokenType::Power)) {
        int rhs = 0;
        if (!parse_const_expr_power(tokens, pos, sym, rhs, silent)) {
            return false;
        }
        result = int_pow(result, rhs, peek_loc(tokens, pos));
    }

    return true;
}

static bool parse_const_expr_multiplicative(const std::vector<Token>& tokens, uint32_t& pos,
        const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_power(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(tokens, pos, TokenType::Multiply)) {
            op = TokenType::Multiply;
        }
        else if (match_token(tokens, pos, TokenType::Divide)) {
            op = TokenType::Divide;
        }
        else if (match_token(tokens, pos, TokenType::Modulo)) {
            op = TokenType::Modulo;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_power(tokens, pos, sym, rhs, silent)) {
            return false;
        }

        switch (op) {
        case TokenType::Multiply:
            result *= rhs;
            break;
        case TokenType::Divide:
            if (rhs == 0) {
                error(peek_loc(tokens, pos), "Division by zero");
                result = 0;
            }
            else {
                result /= rhs;
            }
            break;
        case TokenType::Modulo:
            if (rhs == 0) {
                error(peek_loc(tokens, pos), "Modulo by zero");
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

static bool parse_const_expr_additive(const std::vector<Token>& tokens, uint32_t& pos,
                                      const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_multiplicative(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(tokens, pos, TokenType::Plus)) {
            op = TokenType::Plus;
        }
        else if (match_token(tokens, pos, TokenType::Minus)) {
            op = TokenType::Minus;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_multiplicative(tokens, pos, sym, rhs, silent)) {
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

static bool parse_const_expr_shift(const std::vector<Token>& tokens, uint32_t& pos,
                                   const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_additive(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(tokens, pos, TokenType::LeftShift)) {
            op = TokenType::LeftShift;
        }
        else if (match_token(tokens, pos, TokenType::RightShift)) {
            op = TokenType::RightShift;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_additive(tokens, pos, sym, rhs, silent)) {
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

static bool parse_const_expr_relational(const std::vector<Token>& tokens, uint32_t& pos,
                                        const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_shift(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(tokens, pos, TokenType::LT)) {
            op = TokenType::LT;
        }
        else if (match_token(tokens, pos, TokenType::LE)) {
            op = TokenType::LE;
        }
        else if (match_token(tokens, pos, TokenType::GT)) {
            op = TokenType::GT;
        }
        else if (match_token(tokens, pos, TokenType::GE)) {
            op = TokenType::GE;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_shift(tokens, pos, sym, rhs, silent)) {
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

static bool parse_const_expr_equality(const std::vector<Token>& tokens, uint32_t& pos,
                                      const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_relational(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (true) {
        TokenType op;
        if (match_token(tokens, pos, TokenType::EQ)) {
            op = TokenType::EQ;
        }
        else if (match_token(tokens, pos, TokenType::NE)) {
            op = TokenType::NE;
        }
        else {
            return true;
        }

        int rhs = 0;
        if (!parse_const_expr_relational(tokens, pos, sym, rhs, silent)) {
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

static bool parse_const_expr_bitwise_and(const std::vector<Token>& tokens, uint32_t& pos,
        const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_equality(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (match_token(tokens, pos, TokenType::BitwiseAnd)) {
        int rhs = 0;
        if (!parse_const_expr_equality(tokens, pos, sym, rhs, silent)) {
            return false;
        }
        result &= rhs;
    }

    return true;
}

static bool parse_const_expr_bitwise_xor(const std::vector<Token>& tokens, uint32_t& pos,
        const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_bitwise_and(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (match_token(tokens, pos, TokenType::BitwiseXor)) {
        int rhs = 0;
        if (!parse_const_expr_bitwise_and(tokens, pos, sym, rhs, silent)) {
            return false;
        }
        result ^= rhs;
    }

    return true;
}

static bool parse_const_expr_bitwise_or(const std::vector<Token>& tokens, uint32_t& pos,
                                        const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_bitwise_xor(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (match_token(tokens, pos, TokenType::BitwiseOr)) {
        int rhs = 0;
        if (!parse_const_expr_bitwise_xor(tokens, pos, sym, rhs, silent)) {
            return false;
        }
        result |= rhs;
    }

    return true;
}

static bool parse_const_expr_logical_and(const std::vector<Token>& tokens, uint32_t& pos,
        const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_bitwise_or(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (match_token(tokens, pos, TokenType::LogicalAnd)) {
        int rhs = 0;
        if (!parse_const_expr_bitwise_or(tokens, pos, sym, rhs, silent)) {
            return false;
        }
        result = result && rhs;
    }

    return true;
}

static bool parse_const_expr_logical_xor(const std::vector<Token>& tokens, uint32_t& pos,
        const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_logical_and(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (match_token(tokens, pos, TokenType::LogicalXor)) {
        int rhs = 0;
        if (!parse_const_expr_logical_and(tokens, pos, sym, rhs, silent)) {
            return false;
        }
        result = (!!result) ^ (!!rhs);
    }

    return true;
}

static bool parse_const_expr_logical_or(const std::vector<Token>& tokens, uint32_t& pos,
                                        const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_logical_xor(tokens, pos, sym, result, silent)) {
        return false;
    }

    while (match_token(tokens, pos, TokenType::LogicalOr)) {
        int rhs = 0;
        if (!parse_const_expr_logical_xor(tokens, pos, sym, rhs, silent)) {
            return false;
        }
        result = result || rhs;
    }

    return true;
}

static bool parse_const_expr_conditional(const std::vector<Token>& tokens, uint32_t& pos,
        const ConstSymbols& sym, int& result, bool silent) {
    if (!parse_const_expr_logical_or(tokens, pos, sym, result, silent)) {
        return false;
    }

    if (!match_token(tokens, pos, TokenType::Question)) {
        return true;
    }

    int true_value = 0;
    if (!parse_const_expr_conditional(tokens, pos, sym, true_value, silent)) {
        return false;
    }

    if (!match_token(tokens, pos, TokenType::Colon)) {
        error(peek_loc(tokens, pos), "Missing ':' in conditional expression");
        return false;
    }

    int false_value = 0;
    if (!parse_const_expr_conditional(tokens, pos, sym, false_value, silent)) {
        return false;
    }

    result = result ? true_value : false_value;
    return true;
}

bool eval_const_expr(
    const std::vector<Token>& tokens, uint32_t& pos,
    const ConstSymbols& sym, int& result, bool silent) {
    return parse_const_expr_conditional(tokens, pos, sym, result, silent);
}

bool eval_const_expr(const std::string_view expr, const SourceLoc& loc,
                     const ConstSymbols& sym, int& result,
                     bool silent) {
    std::vector<Token> tokens = tokenize_text(expr, loc);
    uint32_t pos = 0;
    if (!eval_const_expr(tokens, pos, sym, result, silent)) {
        return false;
    }

    if (pos < tokens.size() &&
            tokens[pos].type != TokenType::EndOfLine) {
        error(tokens[pos].loc, "Unexpected token in expression: " +
              g_strings.to_string(tokens[pos].text_id));
        return false;
    }

    return true;
}

int int_pow(int base, int exp, const SourceLoc& loc) {
    if (exp < 0) {
        error(loc, "Negative exponent in expression");
        return 0;
    }

    int result = 1;
    while (exp > 0) {
        result *= base;
        exp--;
    }
    return result;
}
