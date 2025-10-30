//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "expr.h"
#include <vector>
#include <cmath>
#include <cstdint>

bool eval_const_expr(const TokensLine& line, unsigned& i, int& value) {
    // Save original position in case of failure
    unsigned start = i;
    value = 0;

    auto size = line.size();
    if (i >= size) {
        i = start;
        return false;
    }

    // Ensure we start after any spaces
    line.skip_spaces(i);
    if (i >= size) {
        i = start;
        return false;
    }

    // Helpers
    struct Op {
        TokenType type;
        bool unary;
    };

    // precedence: higher -> bind tighter
    auto prec = [&](const Op & op)->int {
        switch (op.type) {
        case TokenType::Power:
            return op.unary ? 18 :
            17; // right assoc for binary power, unary shouldn't be Power
        case TokenType::Multiply:
            return 14;
        case TokenType::Divide:
            return 14;
        case TokenType::Modulus:
            return 14;
        case TokenType::Plus:
            return op.unary ? 16 : 13;
        case TokenType::Minus:
            return op.unary ? 16 : 13;
        case TokenType::ShiftLeft:
            return 12;
        case TokenType::ShiftRight:
            return 12;
        case TokenType::LT:
            return 11;
        case TokenType::LE:
            return 11;
        case TokenType::GT:
            return 11;
        case TokenType::GE:
            return 11;
        case TokenType::EQ:
            return 10;
        case TokenType::NE:
            return 10;
        case TokenType::BitwiseAnd:
            return 9;
        case TokenType::BitwiseXor:
            return 8;
        case TokenType::BitwiseOr:
            return 7;
        case TokenType::LogicalAnd:
            return 6;
        case TokenType::LogicalXor:
            return 5;
        case TokenType::LogicalOr:
            return 4;
        default:
            return 0;
        }
    };

    auto is_right_assoc = [&](const Op & op)->bool {
        // unary and power are right-assoc
        if (op.unary) {
            return true;
        }
        if (op.type == TokenType::Power) {
            return true;
        }
        return false;
    };

    // apply operator: returns false on error (e.g. not enough operands, div by zero)
    std::vector<int> values;
    std::vector<Op> ops;

    auto apply_one = [&](const Op & op)->bool {
        if (op.unary) {
            if (values.empty()) {
                return false;
            }
            int a = values.back();
            values.pop_back();
            int r = 0;
            if (op.type == TokenType::Plus) {
                r = +a;
            }
            else if (op.type == TokenType::Minus) {
                r = -a;
            }
            else if (op.type == TokenType::BitwiseNot) {
                r = ~a;
            }
            else if (op.type == TokenType::LogicalNot) {
                r = (!a) ? 1 : 0;
            }
            else {
                // unknown unary
                return false;
            }
            values.push_back(r);
            return true;
        }
        else {
            if (values.size() < 2) {
                return false;
            }
            int b = values.back();
            values.pop_back();
            int a = values.back();
            values.pop_back();
            // compute a (op) b
            // guard division/mod by zero
            if ((op.type == TokenType::Divide || op.type == TokenType::Modulus) && b == 0) {
                return false;
            }
            int r = 0;
            switch (op.type) {
            case TokenType::Multiply:
                r = a * b;
                break;
            case TokenType::Divide:
                r = a / b;
                break;
            case TokenType::Modulus:
                r = a % b;
                break;
            case TokenType::Plus:
                r = a + b;
                break;
            case TokenType::Minus:
                r = a - b;
                break;
            case TokenType::ShiftLeft:
                r = static_cast<int>(static_cast<unsigned int>(a) << (b & 31));
                break;
            case TokenType::ShiftRight:
                r = a >> (b & 31);
                break;
            case TokenType::LT:
                r = (a < b) ? 1 : 0;
                break;
            case TokenType::LE:
                r = (a <= b) ? 1 : 0;
                break;
            case TokenType::GT:
                r = (a > b) ? 1 : 0;
                break;
            case TokenType::GE:
                r = (a >= b) ? 1 : 0;
                break;
            case TokenType::EQ:
                r = (a == b) ? 1 : 0;
                break;
            case TokenType::NE:
                r = (a != b) ? 1 : 0;
                break;
            case TokenType::BitwiseAnd:
                r = a & b;
                break;
            case TokenType::BitwiseXor:
                r = a ^ b;
                break;
            case TokenType::BitwiseOr:
                r = a | b;
                break;
            case TokenType::LogicalAnd:
                r = (a && b) ? 1 : 0;
                break;
            case TokenType::LogicalOr:
                r = (a || b) ? 1 : 0;
                break;
            case TokenType::LogicalXor:
                r = (a != b) ? 1 : 0;
                break;
            case TokenType::Power: {
                // integer exponentiation (a ** b) ; negative exponent -> 0
                if (b < 0) {
                    r = 0;
                }
                else {
                    long long acc = 1;
                    long long base = a;
                    int exp = b;
                    while (exp) {
                        if (exp & 1) {
                            acc *= base;
                        }
                        exp >>= 1;
                        base *= base;
                    }
                    r = static_cast<int>(acc);
                }
                break;
            }
            default:
                return false;
            }
            values.push_back(r);
            return true;
        }
    };

    auto collapse_ops_while = [&](const Op & incoming)->bool {
        while (!ops.empty()) {
            Op top = ops.back();
            if (top.type == TokenType::LeftParen) {
                break;
            }
            int ptop = prec(top);
            int pin  = prec(incoming);
            if ( (ptop > pin) || (ptop == pin && !is_right_assoc(incoming)) ) {
                ops.pop_back();
                if (!apply_one(top)) {
                    return false;
                }
            }
            else {
                break;
            }
        }
        return true;
    };

    bool expect_operand = true;
    bool any_token_consumed = false;

    while (i < size) {
        // skip spaces before fetching token
        line.skip_spaces(i);
        if (i >= size) {
            break;
        }

        const Token& tk = line[i];
        TokenType tt = tk.type();

        // Accept integers operands
        if (tt == TokenType::Integer) {
            // direct access; Token::int_value() already holds the parsed integer
            values.push_back(tk.int_value());
            ++i;
            expect_operand = false;
            any_token_consumed = true;
            continue;
        }

        // Parenthesis
        if (tt == TokenType::LeftParen) {
            ops.push_back({ TokenType::LeftParen, false });
            ++i;
            expect_operand = true;
            any_token_consumed = true;
            continue;
        }
        if (tt == TokenType::RightParen) {
            // collapse until LParen
            bool found = false;
            while (!ops.empty()) {
                Op top = ops.back();
                ops.pop_back();
                if (top.type == TokenType::LeftParen) {
                    found = true;
                    break;
                }
                if (!apply_one(top)) {
                    i = start;
                    return false;
                }
            }
            if (!found) {
                i = start;    // mismatched paren
                return false;
            }
            ++i;
            expect_operand = false;
            any_token_consumed = true;
            continue;
        }

        // Ternary operator '?'
        if (tt == TokenType::Quest) {
            // We require a condition value already on values stack (or a full expression evaluated)
            if (values.empty()) {
                i = start;
                return false;
            }
            int cond = values.back();
            values.pop_back();
            ++i; // consume '?'
            // parse true branch recursively
            int trueVal = 0;
            if (!eval_const_expr(line, i, trueVal)) {
                i = start;
                return false;
            }
            // skip spaces before checking ':'
            line.skip_spaces(i);
            // next token must be ':'
            if (i >= size || line[i].type() != TokenType::Colon) {
                i = start;
                return false;
            }
            ++i; // consume ':'
            int falseVal = 0;
            if (!eval_const_expr(line, i, falseVal)) {
                i = start;
                return false;
            }
            int res = (cond != 0) ? trueVal : falseVal;
            values.push_back(res);
            expect_operand = false;
            any_token_consumed = true;
            continue;
        }

        // If colon encountered at top-level, it's not part of this expression -> stop
        if (tt == TokenType::Colon || tt == TokenType::Comma) {
            break;
        }

        // Operators (binary or unary)
        bool is_unary = false;
        if (tt == TokenType::Plus || tt == TokenType::Minus) {
            is_unary = expect_operand;
        }
        else if (tt == TokenType::BitwiseNot || tt == TokenType::LogicalNot) {
            is_unary = true;
        }
        else {
            is_unary = false;
        }

        // Recognize other binary operators
        bool is_operator_token =
            tt == TokenType::Plus || tt == TokenType::Minus ||
            tt == TokenType::Multiply || tt == TokenType::Divide
            || tt == TokenType::Modulus ||
            tt == TokenType::Power ||
            tt == TokenType::ShiftLeft || tt == TokenType::ShiftRight ||
            tt == TokenType::LT || tt == TokenType::LE || tt == TokenType::GT
            || tt == TokenType::GE ||
            tt == TokenType::EQ || tt == TokenType::NE ||
            tt == TokenType::BitwiseAnd || tt == TokenType::BitwiseXor
            || tt == TokenType::BitwiseOr ||
            tt == TokenType::LogicalAnd || tt == TokenType::LogicalOr
            || tt == TokenType::LogicalXor ||
            tt == TokenType::BitwiseNot || tt == TokenType::LogicalNot;

        if (!is_operator_token) {
            // Not part of expression -> stop parsing
            break;
        }

        // Build Op for this token
        Op cur{ tt, is_unary };

        // For unary operators we just push onto ops stack (right-assoc)
        if (is_unary) {
            ops.push_back(cur);
            ++i;
            expect_operand = true;
            any_token_consumed = true;
            continue;
        }
        else {
            // Binary operator: collapse according to precedence and associativity
            if (!collapse_ops_while(cur)) {
                i = start;
                return false;
            }
            ops.push_back(cur);
            ++i;
            expect_operand = true;
            any_token_consumed = true;
            continue;
        }
    } // main loop

    if (!any_token_consumed) {
        // nothing parsed as expression
        i = start;
        return false;
    }

    // Collapse remaining operators
    while (!ops.empty()) {
        Op top = ops.back();
        ops.pop_back();
        if (top.type == TokenType::LeftParen) {
            i = start;    // mismatched paren
            return false;
        }
        if (!apply_one(top)) {
            i = start;
            return false;
        }
    }

    if (values.empty()) {
        i = start;
        return false;
    }

    // Last value is the result
    value = values.back();

    // Success: i already points after last consumed token
    return true;
}
