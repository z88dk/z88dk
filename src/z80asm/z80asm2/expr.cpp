//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "expr.h"
#include <cmath>
#include <cstdint>
#include <vector>

// return precedence for given token type and unary flag
static int prec(TokenType type, bool unary) {
    // Use a switch so compiler can optimize the dispatch
    switch (type) {
    case TokenType::Power:
        return unary ? 18 : 17; // unary power (shouldn't really happen) vs binary power

    case TokenType::Plus:
    case TokenType::Minus:
        return unary ? 16 : 13;

    case TokenType::Multiply:
    case TokenType::Divide:
    case TokenType::Modulus:
        return 14;

    case TokenType::ShiftLeft:
    case TokenType::ShiftRight:
        return 12;

    case TokenType::LT:
    case TokenType::LE:
    case TokenType::GT:
    case TokenType::GE:
        return 11;

    case TokenType::EQ:
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
}

// determine if an operator (given by type and unary flag) is right-associative
static bool is_right_assoc(TokenType type, bool unary) {
    // unary operators and power are right-assoc
    if (unary) {
        return true;
    }
    if (type == TokenType::Power) {
        return true;
    }
    return false;
}

// Return true if token type represents an operator (binary or unary).
// Implemented as a switch to let the compiler optimize the dispatch.
static bool is_operator_token(TokenType tt) {
    switch (tt) {
    case TokenType::Plus:
    case TokenType::Minus:
    case TokenType::Multiply:
    case TokenType::Divide:
    case TokenType::Modulus:
    case TokenType::Power:
    case TokenType::ShiftLeft:
    case TokenType::ShiftRight:
    case TokenType::LT:
    case TokenType::LE:
    case TokenType::GT:
    case TokenType::GE:
    case TokenType::EQ:
    case TokenType::NE:
    case TokenType::BitwiseAnd:
    case TokenType::BitwiseXor:
    case TokenType::BitwiseOr:
    case TokenType::LogicalAnd:
    case TokenType::LogicalOr:
    case TokenType::LogicalXor:
    case TokenType::BitwiseNot:
    case TokenType::LogicalNot:
        return true;
    default:
        return false;
    }
}

// RPN item used by the two-step evaluator
struct RPNItem {
    enum Kind { Value, Op } kind;
    int value;              // valid if kind == Value
    TokenType op;           // valid if kind == Op
    bool unary{ false };    // valid if kind == Op
};

// Op representation for the shunting-yard stage (moved out of to_rpn so helper can use it)
struct RPNOp {
    TokenType type;
    bool unary;
};

// Collapse operators from the ops stack into the RPN output according to precedence/associativity.
static bool collapse_ops_while(std::vector<RPNOp>& ops,
                               const RPNOp& incoming, std::vector<RPNItem>& out) {
    while (!ops.empty()) {
        RPNOp top = ops.back();
        if (top.type == TokenType::LeftParen) {
            break;
        }
        int ptop = prec(top.type, top.unary);
        int pin  = prec(incoming.type, incoming.unary);
        if ((ptop > pin) || (ptop == pin
                             && !is_right_assoc(incoming.type, incoming.unary))) {
            ops.pop_back();
            RPNItem item;
            item.kind = RPNItem::Op;
            item.op = top.type;
            item.unary = top.unary;
            out.push_back(item);
        }
        else {
            break;
        }
    }
    return true;
}

// Convert infix TokensLine starting at 'i' to RPN vector 'out'.
// Stops when it reaches end-of-line, or a colon/comma (these are NOT consumed).
// Advances 'i' to the token following the last consumed token (or to the colon/comma).
static bool to_rpn(const TokensLine& line, unsigned& i,
                   std::vector<RPNItem>& out) {
    unsigned start = i;
    auto size = line.size();
    if (i >= size) {
        i = start;
        return false;
    }

    line.skip_spaces(i);
    if (i >= size) {
        i = start;
        return false;
    }

    std::vector<RPNOp> ops;
    bool expect_operand = true;
    bool any_token_consumed = false;

    while (i < size) {
        line.skip_spaces(i);
        if (i >= size) {
            break;
        }

        const Token& tk = line[i];
        TokenType tt = tk.type();

        // Accept integers operands
        if (tt == TokenType::Integer) {
            RPNItem it{};
            it.kind = RPNItem::Value;
            it.value = tk.int_value();
            out.push_back(it);
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
                RPNOp top = ops.back();
                ops.pop_back();
                if (top.type == TokenType::LeftParen) {
                    found = true;
                    break;
                }
                RPNItem item;
                item.kind = RPNItem::Op;
                item.op = top.type;
                item.unary = top.unary;
                out.push_back(item);
            }
            if (!found) {
                i = start; // mismatched paren
                return false;
            }
            ++i;
            expect_operand = false;
            any_token_consumed = true;
            continue;
        }

        // Ternary operator '?'
        if (tt == TokenType::Quest) {
            // condition must already be present in output (like values stack)
            if (out.empty()) {
                i = start;
                return false;
            }
            ++i; // consume '?'
            // parse true branch RPN until colon (do not consume colon)
            std::vector<RPNItem> true_rpn;
            if (!to_rpn(line, i, true_rpn)) {
                i = start;
                return false;
            }
            line.skip_spaces(i);
            if (i >= size || line[i].type() != TokenType::Colon) {
                i = start;
                return false;
            }
            ++i; // consume ':'
            // parse false branch RPN (stops at colon/comma/end)
            std::vector<RPNItem> false_rpn;
            if (!to_rpn(line, i, false_rpn)) {
                i = start;
                return false;
            }
            // append true then false RPN, then ternary op
            out.insert(out.end(), true_rpn.begin(), true_rpn.end());
            out.insert(out.end(), false_rpn.begin(), false_rpn.end());
            RPNItem tern{};
            tern.kind = RPNItem::Op;
            tern.op = TokenType::Quest; // treat as a 3-operand operator in evaluation
            tern.unary = false;
            out.push_back(tern);
            expect_operand = false;
            any_token_consumed = true;
            continue;
        }

        // If colon/comma encountered at top-level, stop and don't consume it
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

        // Use the factored-out helper to detect operator tokens
        if (!is_operator_token(tt)) {
            // Not part of expression -> stop parsing
            break;
        }

        RPNOp cur{ tt, is_unary };
        if (is_unary) {
            ops.push_back(cur);
            ++i;
            expect_operand = true;
            any_token_consumed = true;
            continue;
        }
        else {
            // Binary operator: collapse according to precedence and associativity
            if (!collapse_ops_while(ops, cur, out)) {
                i = start;
                return false;
            }
            ops.push_back(cur);
            ++i;
            expect_operand = true;
            any_token_consumed = true;
            continue;
        }
    } // main parsing loop

    if (!any_token_consumed) {
        i = start;
        return false;
    }

    // Collapse remaining operators to output
    while (!ops.empty()) {
        RPNOp top = ops.back();
        ops.pop_back();
        if (top.type == TokenType::LeftParen) {
            i = start; // mismatched paren
            return false;
        }
        RPNItem item;
        item.kind = RPNItem::Op;
        item.op = top.type;
        item.unary = top.unary;
        out.push_back(item);
    }

    return true;
}

// integer power helper (fast exponentiation). negative exponent -> 0 (matches previous behaviour)
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

// Evaluate an RPN vector produced by to_rpn. result in 'value'.
static bool eval_rpn(const std::vector<RPNItem>& rpn, int& value) {
    std::vector<int> stack;
    stack.reserve(rpn.size());

    for (const auto& it : rpn) {
        if (it.kind == RPNItem::Value) {
            stack.push_back(it.value);
            continue;
        }

        // Operator
        if (it.unary) {
            if (stack.empty()) {
                return false;
            }
            int a = stack.back();
            stack.pop_back();
            int r = 0;
            if (it.op == TokenType::Plus) {
                r = +a;
            }
            else if (it.op == TokenType::Minus) {
                r = -a;
            }
            else if (it.op == TokenType::BitwiseNot) {
                r = ~a;
            }
            else if (it.op == TokenType::LogicalNot) {
                r = (!a) ? 1 : 0;
            }
            else {
                return false;
            }
            stack.push_back(r);
        }
        else {
            if (it.op == TokenType::Quest) {
                // ternary: expects 3 operands: cond true false (in that order in RPN)
                if (stack.size() < 3) {
                    return false;
                }
                int falseVal = stack.back();
                stack.pop_back();
                int trueVal  = stack.back();
                stack.pop_back();
                int cond     = stack.back();
                stack.pop_back();
                int res = (cond != 0) ? trueVal : falseVal;
                stack.push_back(res);
                continue;
            }

            if (stack.size() < 2) {
                return false;
            }
            int b = stack.back();
            stack.pop_back();
            int a = stack.back();
            stack.pop_back();

            // guard division/mod by zero
            if ((it.op == TokenType::Divide ||
                    it.op == TokenType::Modulus) && b == 0) {
                return false;
            }

            int r = 0;
            switch (it.op) {
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
            case TokenType::Power:
                r = ipow(a, b);
                break;
            default:
                return false;
            }
            stack.push_back(r);
        }
    }

    if (stack.empty()) {
        return false;
    }
    value = stack.back();
    return true;
}

bool eval_const_expr(const TokensLine& line, unsigned& i, int& value) {
    // two-step: convert to RPN (syntax-check) then evaluate RPN
    unsigned start = i;
    value = 0;

    std::vector<RPNItem> rpn;
    if (!to_rpn(line, i, rpn)) {
        i = start;
        return false;
    }

    if (!eval_rpn(rpn, value)) {
        i = start;
        return false;
    }

    // success: i already points after last consumed token (or at colon/comma)
    return true;
}
