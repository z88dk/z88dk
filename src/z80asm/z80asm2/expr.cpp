//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "expr.h"
#include "symbol_table.h"
#include "utils.h"
#include <cmath>
#include <cstdint>
#include <vector>

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

void Expr::clear() {
    line_.clear();
    rpn_items_.clear();
}

bool Expr::parse(const TokensLine& line, unsigned& i) {
    clear();
    line_.set_location(line.location());

    unsigned start = i;
    line.skip_spaces(i);
    std::vector<RPNItem> items;
    bool ok = try_parse(line, i, items);
    if (!ok) {
        i = start;
        return false;
    }
    else {
        // copy operators and tokens to expression
        rpn_items_.insert(rpn_items_.end(), items.begin(), items.end());
        unsigned end = i;
        for (unsigned j = start; j < end; ++j) {
            line_.push_back(line[j]);
        }
        return true;
    }
}

bool Expr::evaluate(int& out_value) {
    out_value = 0;
    is_extern_ = false;
    is_undefined_ = false;
    is_constant_ = true;

    std::vector<int> stack;
    stack.reserve(rpn_items_.size());

    for (const auto& it : rpn_items_) {
        if (it.kind == RPNItem::Value) {
            stack.push_back(it.value);
            continue;
        }

        // lookup symbol table
        if (it.kind == RPNItem::Symbol) {
            const Symbol& symbol = g_symbol_table.get_symbol(it.name);
            if (symbol.is_extern) {
                is_extern_ = true;
                if (!silent_) {
                    g_errors.error(ErrorCode::ExternSymbol, it.name);
                }
                return false;
            }
            if (!symbol.is_defined) {
                is_undefined_ = true;
                if (!silent_) {
                    g_errors.error(ErrorCode::UndefinedSymbol, it.name);
                }
                return false;
            }
            if (!symbol.is_constant) {
                is_constant_ = false;
                if (!silent_) {
                    g_errors.error(ErrorCode::NotConstantSymbol, it.name);
                }
                return false;
            }
            stack.push_back(symbol.value);
            continue;
        }

        // Operator
        if (it.unary) {
            if (stack.empty()) {
                if (!silent_) {
                    g_errors.error(ErrorCode::InsufficientOperands);
                }
                return false;
            }
            int a = stack.back();
            stack.pop_back();
            int r = 0;
            switch (it.op) {
            case TokenType::Plus:
                r = +a;
                break;
            case TokenType::Minus:
                r = -a;
                break;
            case TokenType::BitwiseNot:
                r = ~a;
                break;
            case TokenType::LogicalNot:
                r = (!a) ? 1 : 0;
                break;
            default:
                if (!silent_) {
                    g_errors.error(ErrorCode::InvalidSyntax);
                }
                return false;
            }
            stack.push_back(r);
        }
        else {
            if (it.op == TokenType::Quest) {
                // ternary: expects 3 operands: cond true false (in that order in RPN)
                if (stack.size() < 3) {
                    if (!silent_) {
                        g_errors.error(ErrorCode::InsufficientOperands);
                    }
                    return false;
                }
                int false_val = stack.back();
                stack.pop_back();
                int true_val = stack.back();
                stack.pop_back();
                int cond = stack.back();
                stack.pop_back();
                int res = (cond != 0) ? true_val : false_val;
                stack.push_back(res);
                continue;
            }

            if (stack.size() < 2) {
                if (!silent_) {
                    g_errors.error(ErrorCode::InsufficientOperands);
                }
                return false;
            }
            int b = stack.back();
            stack.pop_back();
            int a = stack.back();
            stack.pop_back();

            // guard division/mod by zero
            if ((it.op == TokenType::Divide ||
                    it.op == TokenType::Modulus) && b == 0) {
                if (!silent_) {
                    g_errors.error(ErrorCode::DivisionByZero);
                }
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
                if (!silent_) {
                    g_errors.error(ErrorCode::InvalidSyntax);
                }
                return false;
            }
            stack.push_back(r);
        }
    }

    if (stack.empty()) {
        if (!silent_) {
            g_errors.error(ErrorCode::InsufficientOperands);
        }
        return false;
    }
    out_value = stack.back();
    return true;
}

std::string Expr::to_string() const {
    std::string out;
    for (auto& t : line_.tokens()) {
        out += t.text();
    }
    return trim(out);
}

// return precedence for given token type and unary flag
int Expr::prec(TokenType type, bool unary) {
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
bool Expr::is_right_assoc(TokenType type, bool unary) {
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
bool Expr::is_operator_token(TokenType tt) {
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

// Sequence lookahead: allow chains of unary ops before a real operand
bool Expr::can_start_operand_sequence(const TokensLine& line, unsigned j) {
    const unsigned size = line.size();
    line.skip_spaces(j);
    if (j >= size) {
        return false;
    }

    // allow a chain of unary operators
    while (j < size) {
        TokenType t = line[j].type();
        if (t == TokenType::Plus || t == TokenType::Minus ||
                t == TokenType::BitwiseNot || t == TokenType::LogicalNot) {
            ++j;
            line.skip_spaces(j);
            continue;
        }
        break;
    }

    if (j >= size) {
        return false;
    }

    switch (line[j].type()) {
    case TokenType::Integer:
    case TokenType::Identifier:
    case TokenType::LeftParen:
        return true;
    default:
        return false;
    }
}

// Convert infix TokensLine starting at 'i' to RPN vector 'rpn_items_'.
// Stops when it reaches end-of-line, or a token that is not part of
// the expression.
// Advances 'i' to the token following the last consumed token
bool Expr::try_parse(const TokensLine& line, unsigned& i,
                     std::vector<RPNItem>& out) {
    auto size = line.size();
    if (i >= size) {
        if (!silent_) {
            g_errors.error(ErrorCode::InvalidSyntax, "Expression expected");
        }
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

        // Accept integer operand
        if (tt == TokenType::Integer) {
            RPNItem it;
            it.kind = RPNItem::Value;
            it.value = tk.int_value();
            out.push_back(it);
            ++i;
            expect_operand = false;
            any_token_consumed = true;
            continue;
        }

        // Accept identifier operand
        if (tt == TokenType::Identifier) {
            RPNItem it;
            it.kind = RPNItem::Symbol;
            it.name = tk.text();
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
                if (top.op == TokenType::LeftParen) {
                    found = true;
                    break;
                }
                RPNItem item;
                item.kind = RPNItem::Op;
                item.op = top.op;
                item.unary = top.unary;
                out.push_back(item);
            }
            if (!found) {
                return true; // extra ')' after a valid expr: leave it unconsumed
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
                if (!silent_) {
                    g_errors.error(ErrorCode::InvalidSyntax, "Unexpected '?'");
                }
                return false;
            }
            ++i; // consume '?'

            // parse true branch RPN until colon (do not consume colon)
            std::vector<RPNItem> true_rpn;
            if (!try_parse(line, i, true_rpn)) {
                if (!silent_) {
                    g_errors.error(ErrorCode::InvalidSyntax, "Ternary expression");
                }
                return false;
            }

            line.skip_spaces(i);
            if (i >= size || line[i].type() != TokenType::Colon) {
                if (!silent_) {
                    g_errors.error(ErrorCode::InvalidSyntax, "Expected ':'");
                }
                return false;
            }
            ++i; // consume ':'

            // parse false branch RPN (stops at colon/comma/end)
            std::vector<RPNItem> false_rpn;
            if (!try_parse(line, i, false_rpn)) {
                if (!silent_) {
                    g_errors.error(ErrorCode::InvalidSyntax, "Ternary expression");
                }
                return false;
            }

            // append true then false RPN, then ternary op
            out.insert(out.end(), true_rpn.begin(), true_rpn.end());
            out.insert(out.end(), false_rpn.begin(), false_rpn.end());
            RPNItem tern;
            tern.kind = RPNItem::Op;
            tern.op = TokenType::Quest; // treat as a 3-operand operator in evaluation
            tern.unary = false;
            out.push_back(tern);
            expect_operand = false;
            any_token_consumed = true;
            continue;
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

        // REJECT binary operator when an operand is expected (e.g., "*1" at start)
        if (!is_unary && expect_operand) {
            if (!any_token_consumed) {
                if (!silent_) {
                    g_errors.error(ErrorCode::InvalidSyntax, "Expression expected");
                }
                return false;
            }
            break; // leave it unconsumed for outer parser
        }

        RPNOp cur{ tt, is_unary };
        if (is_unary) {
            // Lookahead: only consume unary op if a valid operand sequence follows.
            unsigned j = i + 1;
            if (!can_start_operand_sequence(line, j)) {
                // dangling unary operator: if nothing parsed yet, fail; else stop here
                break;
            }
            ops.push_back(cur);
            ++i;
            expect_operand = true;
            any_token_consumed = true;
            continue;
        }
        else {
            // Binary operator: only consume if a valid RHS can start (allowing unary chain)
            unsigned j = i + 1;
            if (!can_start_operand_sequence(line, j)) {
                // dangling binary operator - stop before it
                break;
            }

            // Binary operator: collapse according to precedence
            // and associativity
            collapse_ops_while(ops, cur, out);
            ops.push_back(cur);
            ++i;
            expect_operand = true;
            any_token_consumed = true;
            continue;
        }
    } // main parsing loop

    if (!any_token_consumed) {
        if (!silent_) {
            g_errors.error(ErrorCode::InvalidSyntax, "Expression expected");
        }
        return false;
    }

    // Collapse remaining operators to output
    while (!ops.empty()) {
        RPNOp top = ops.back();
        ops.pop_back();
        if (top.op == TokenType::LeftParen) {
            if (!silent_) {
                g_errors.error(ErrorCode::InvalidSyntax, "Mismatched parenthesis");
            }
            return false;
        }
        RPNItem item;
        item.kind = RPNItem::Op;
        item.op = top.op;
        item.unary = top.unary;
        out.push_back(item);
    }

    return true;
}

// Collapse operators from the ops stack into the RPN output according to precedence/associativity.
void Expr::collapse_ops_while(std::vector<RPNOp>& ops,
                              const RPNOp& incoming, std::vector<RPNItem>& out) {
    while (!ops.empty()) {
        RPNOp top = ops.back();
        if (top.op == TokenType::LeftParen) {
            break;
        }
        int ptop = prec(top.op, top.unary);
        int pin = prec(incoming.op, incoming.unary);
        if ((ptop > pin) ||
                (ptop == pin && !is_right_assoc(incoming.op, incoming.unary))) {
            ops.pop_back();
            RPNItem item;
            item.kind = RPNItem::Op;
            item.op = top.op;
            item.unary = top.unary;
            out.push_back(item);
        }
        else {
            break;
        }
    }
}
