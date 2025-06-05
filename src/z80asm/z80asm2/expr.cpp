//-----------------------------------------------------------------------------
// z80asm
// Expression
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "expr.h"
#include "symbol.h"
#include "utils.h"
#include <cassert>
#include <stack>
using namespace std;

bool Expr::is_unary(Scanner& in) const {
    if (in.get_pos() == 0)
        return true;
    const Token& prev = in.peek(-1);
    switch (prev.get_ttype()) {
    case TType::OPERATOR:
    case TType::LPAREN:
    case TType::QUEST:
    case TType::COLON:
        return true;
    default:
        return false;
    }
}

// Shunting Yard algotithm to convert infix to postfix (RPN)
bool Expr::to_RPN(Scanner& in) {
    stack<Token> op_stack;

    while (!in.peek().is(TType::END)) {
        const Token& token = in.peek();
        TType ttype = token.get_ttype();
        Operator op = token.get_operator();

        if (ttype == TType::INT || ttype == TType::IDENT || ttype == TType::ASMPC) {
            m_postfix.push_back(token);
            in.next();
        }
        else if (ttype == TType::OPERATOR) {

            // Adjust to unary operator
            bool unary = is_unary(in);
            if (unary) {
                switch (op) {
                case Operator::PLUS: op = Operator::UPLUS; break;
                case Operator::MINUS: op = Operator::UMINUS; break;
                default:;
                }
            }

            while (!op_stack.empty()) {
                const Token& top = op_stack.top();
                if (top.get_ttype() != TType::OPERATOR)
                    break;
                Operator top_op = top.get_operator();

                const OperatorInfo& op1 = OperatorTable::get_info(op);
                const OperatorInfo& op2 = OperatorTable::get_info(top_op);

                if ((op1.associativity == Associativity::Left && op1.precedence <= op2.precedence) ||
                    (op1.associativity == Associativity::Right && op1.precedence < op2.precedence)) {
                    m_postfix.push_back(top);
                    op_stack.pop();
                }
                else {
                    break;
                }
            }

            // Push operator (mark unary ops explicitly)
            Token push_op = token;
            push_op.set_operator(op);       // set unary operator
            op_stack.push(push_op);
            in.next();
        }
        else if (ttype == TType::LPAREN) {
            op_stack.push(token);
            in.next();
        }
        else if (ttype == TType::RPAREN) {
            while (!op_stack.empty() && op_stack.top().get_ttype() != TType::LPAREN) {
                m_postfix.push_back(op_stack.top());
                op_stack.pop();
            }
            if (op_stack.empty()) {
                m_status = Status::MISMATCHED_PARENS;
                return false;
            }
            op_stack.pop(); // pop '('
            in.next();
        }
        else if (ttype == TType::QUEST) {
            op_stack.push(token);
            in.next();
        }
        else if (ttype == TType::COLON) {
            while (!op_stack.empty() && op_stack.top().get_ttype() != TType::QUEST) {
                m_postfix.push_back(op_stack.top());
                op_stack.pop();
            }
            if (op_stack.empty()) {
                m_status = Status::MISMATCHED_TERNARY;
                return false;
            }
            op_stack.pop(); // Pop '?'

            Token push_op{ TType::OPERATOR, false };
            push_op.set_operator(Operator::TERNARY);
            op_stack.push(push_op);
            in.next();
        }
        else {
            break;      // end of expression
        }
    }

    while (!op_stack.empty()) {
        if (op_stack.top().get_ttype() == TType::LPAREN || op_stack.top().get_ttype() == TType::RPAREN) {
            m_status = Status::MISMATCHED_PARENS;
            return false;
        }
        m_postfix.push_back(op_stack.top());
        op_stack.pop();
    }

    if (m_postfix.empty()) {
        m_status = Status::OPERAND_EXPECTED;
        return false;   // no tokens
    }
    else {
        return check_syntax();
    }
}

// check if all arguments to all operators were given
bool Expr::check_syntax() {
    stack<int> eval_stack;
    for (auto& token : m_postfix) {
        TType ttype = token.get_ttype();

        if (ttype == TType::INT || ttype == TType::IDENT || ttype == TType::ASMPC) {
            eval_stack.push(1); // dummy value
        }
        else if (ttype == TType::OPERATOR) {
            auto info = OperatorTable::get_info(token.get_operator());

            size_t required = 0;
            switch (info.arity) {
            case Arity::Unary: required = 1; break;
            case Arity::Binary: required = 2; break;
            case Arity::Ternary: required = 3; break;
            }

            if (eval_stack.size() < required) {
                m_status = Status::INSUFICIENT_OPERANDS;
                return false;
            }

            // Pop required operands and push result
            for (size_t i = 0; i < required; ++i)
                eval_stack.pop();
            eval_stack.push(1);
        }
    }

    if (eval_stack.size() == 0) {
        m_status = Status::OPERAND_EXPECTED;
        return false;   // no tokens
    }
    else if (eval_stack.size() > 1) {
        m_status = Status::TOO_MANY_OPERANDS;
        return false;
    }
    else {
        return true;
    }
}

bool Expr::parse(const string& line) {
    Scanner in;
    m_status = Status::OK;

    if (!in.scan(line)) {
        m_status = Status::SCAN_FAILED;
        m_infix.clear();
        m_postfix.clear();
        return false;   // scan failed
    }
    else if (!parse(in)) {
        return false;   // parse failed, m_status is filled
    }
    else if (!in.peek().is_end()) {
        m_status = Status::EOL_EXPECTED;
        m_infix.clear();
        m_postfix.clear();
        return false;   // extra input
    }
    else {
        assert(m_status == Status::OK);
        return true;
    }
}

bool Expr::parse(Scanner& in) {
    m_infix.clear();
    m_postfix.clear();
    m_status = Status::OK;
    int pos0 = in.get_pos();

    if (to_RPN(in)) {
        // copy infix tokens
        for (int i = pos0; i < in.get_pos(); ++i)
            m_infix.push_back(in[i]);
        return true;
    }
    else {
        in.set_pos(pos0); // reset to original position
        m_infix.clear();
        m_postfix.clear();
        return false;
    }
}

bool Expr::eval(int asmpc, Symtab* symtab, int& result) {
    stack<int> eval_stack;
    result = 0;
    int x1, x2, x3;

    for (auto& token : m_postfix) {
        switch (token.get_ttype()) {
        case TType::INT:
            eval_stack.push(token.get_ivalue());
            break;

        case TType::IDENT:
            if (!symtab->eval(asmpc, token.get_svalue(), x1))
                return false;
            else
                eval_stack.push(x1);
            break;

        case TType::ASMPC:
            eval_stack.push(asmpc);
            break;

        case TType::OPERATOR:
            switch (token.get_operator()) {
            case Operator::POWER:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(ipow(x1, x2));
                break;

            case Operator::UPLUS:
                assert(eval_stack.size() >= 1);
                break;

            case Operator::UMINUS:
                assert(eval_stack.size() >= 1);
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(-x1);
                break;

            case Operator::LOG_NOT:
                assert(eval_stack.size() >= 1);
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 ? 0 : 1);
                break;

            case Operator::BIN_NOT:
                assert(eval_stack.size() >= 1);
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(~x1);
                break;

            case Operator::MULT:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 * x2);
                break;

            case Operator::DIV:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                if (x2 == 0) {
                    g_error.error_division_by_zero();
                    eval_stack.push(0);
                }
                else {
                    eval_stack.push(x1 / x2);
                }
                break;

            case Operator::MOD:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                if (x2 == 0) {
                    g_error.error_division_by_zero();
                    eval_stack.push(0);
                }
                else {
                    eval_stack.push(x1 % x2);
                }
                break;

            case Operator::PLUS:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 + x2);
                break;

            case Operator::MINUS:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 - x2);
                break;

            case Operator::LSHIFT:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 << x2);
                break;

            case Operator::RSHIFT:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 >> x2);
                break;

            case Operator::LT:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 < x2);
                break;

            case Operator::LE:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 <= x2);
                break;

            case Operator::GT:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 > x2);
                break;

            case Operator::GE:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 >= x2);
                break;

            case Operator::EQ:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 == x2);
                break;

            case Operator::NE:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 != x2);
                break;

            case Operator::BIN_AND:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 & x2);
                break;

            case Operator::BIN_OR:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 | x2);
                break;

            case Operator::BIN_XOR:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 ^ x2);
                break;

            case Operator::LOG_AND:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 && x2 ? 1 : 0);
                break;

            case Operator::LOG_OR:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 || x2 ? 1 : 0);
                break;

            case Operator::LOG_XOR:
                assert(eval_stack.size() >= 2);
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 == x2 ? 0 : 1);
                break;

            case Operator::TERNARY:
                assert(eval_stack.size() >= 3);
                x3 = eval_stack.top(); eval_stack.pop();
                x2 = eval_stack.top(); eval_stack.pop();
                x1 = eval_stack.top(); eval_stack.pop();
                eval_stack.push(x1 ? x2 : x3);
                break;

            default:
                assert(false && "Unknown operator");
            }
            break;

        default:
            assert(false && "Unknown token type");
        }
    }

    assert(eval_stack.size() == 1);
    result = eval_stack.top();
    eval_stack.pop();
    return true;
}

string Expr::to_string() const {
    Scanner expr{ m_infix };
    return expr.to_string();
}

string Expr::rpn_to_string() const {
    string output;
    for (auto& token : m_postfix) {
        output += token.to_string() + " ";
    }
    return output;
}

Expr* Expr::clone() {
    auto new_expr = new Expr;
    new_expr->m_infix = m_infix;
    new_expr->m_postfix = m_postfix;
    new_expr->m_status = m_status;
    return new_expr;
}

