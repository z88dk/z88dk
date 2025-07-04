//-----------------------------------------------------------------------------
// z80asm
// Floating point support
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "zfloat.h"
#include <cassert>
#include <cmath>
#include <functional>
#include <iostream>
#include <string>
using namespace std;

FloatExpr::FloatExpr(const FloatExpr& other) {
    m_infix = other.m_infix;
    m_postfix = other.m_postfix;
	m_pos0 = other.m_pos0;
}

FloatExpr& FloatExpr::operator=(const FloatExpr& other) {
    if (&other != this) {
        m_infix = other.m_infix;
        m_postfix = other.m_postfix;
        m_pos0 = other.m_pos0;
    }
	return *this;
}

void FloatExpr::clear() {
    m_infix.clear();
    m_postfix.clear();
    m_pos0 = 0;
}

bool FloatExpr::empty() const {
    return m_infix.empty() && m_postfix.empty();
}

bool FloatExpr::parse(const string& line) {
    Scanner in;
    if (!in.scan(line)) {
        clear();
        return false;   // scan failed
    }
    else if (!parse(in)) {
        clear();
        return false;   // parse failed
    }
    else if (!in.peek().is_end()) {
        g_error->error_expected_eol();
        clear();
        return false;   // extra input
    }
    else {
        return true;
    }
}

bool FloatExpr::parse(Scanner& in) {
    clear();
    m_pos0 = in.pos();

    if (to_rpn(in)) {
        // copy infix tokens
        int pos1 = in.pos();
        for (int i = m_pos0; i < pos1; ++i)
            m_infix.push_back(in[i]);
        return true;
    }
    else {
        in.set_pos(m_pos0); // reset to original position
        clear();
        return false;
    }
}

double FloatExpr::eval() const {
    std::stack<double> stack;

    for (const Token& tok : m_postfix) {
        switch (tok.ttype()) {
        case TType::FLOAT:
            stack.push(tok.fvalue());
            break;

        case TType::OPERATOR: {
            if (tok.operator_() == Operator::UNARY_MINUS ||
                tok.operator_() == Operator::UNARY_PLUS ||
                tok.operator_() == Operator::LOG_NOT || 
                tok.operator_() == Operator::BIN_NOT) {
                if (stack.empty()) assert(false && "Missing operand for unary operator");
                double a = stack.top(); stack.pop();
                switch (tok.operator_()) {
                case Operator::UNARY_MINUS: stack.push(-a); break;
                case Operator::UNARY_PLUS:  stack.push(+a); break;
                case Operator::LOG_NOT:     stack.push(!a); break;
                case Operator::BIN_NOT:     stack.push(~static_cast<int>(a)); break;
                default: break;
                }
            }
            else {
                if (stack.size() < 2) assert(false && "Missing operands for binary operator");
                double b = stack.top(); stack.pop();
                double a = stack.top(); stack.pop();
                switch (tok.operator_()) {
                case Operator::PLUS: stack.push(a + b); break;
                case Operator::MINUS: stack.push(a - b); break;
                case Operator::MULT: stack.push(a * b); break;
                case Operator::DIV: 
                    if (b < 1e-9) {
                        g_error->error_division_by_zero(); 
						stack.push(0); // handle division by zero
                    }
                    else {
                        stack.push(a / b);
					}
                    break;
                case Operator::MOD:
                    if (b < 1e-9) {
                        g_error->error_division_by_zero();
                        stack.push(0); // handle division by zero
                    }
                    else {
                        stack.push(fmod(a, b));
                    }
                    break;
                case Operator::POWER: stack.push(pow(a, b)); break;
                case Operator::LT: stack.push(a < b); break;
                case Operator::GT: stack.push(a > b); break;
                case Operator::LE: stack.push(a <= b); break;
                case Operator::GE: stack.push(a >= b); break;
                case Operator::EQ: stack.push(a == b); break;
                case Operator::NE: stack.push(a != b); break;
                case Operator::LOG_AND: stack.push(a && b); break;
                case Operator::LOG_XOR: stack.push(a != b); break;
                case Operator::LOG_OR: stack.push(a || b); break;
                case Operator::BIN_AND: stack.push(static_cast<int>(a) & static_cast<int>(b)); break;
                case Operator::BIN_OR: stack.push(static_cast<int>(a) | static_cast<int>(b)); break;
                case Operator::BIN_XOR: stack.push(static_cast<int>(a) ^ static_cast<int>(b)); break;
                case Operator::LSHIFT: stack.push(static_cast<int>(a) << static_cast<int>(b)); break;
                case Operator::RSHIFT: stack.push(static_cast<int>(a) >> static_cast<int>(b)); break;
                default: break;
                }
            }
            break;
        }

        case TType::IDENT: {
            if (stack.empty()) assert(false && "Missing operand for function");
            double b = stack.top(); stack.pop();
            if (tok.keyword() == Keyword::POW ||
                tok.keyword() == Keyword::ATAN2 ||
                tok.keyword() == Keyword::FMOD) {
                if (stack.empty()) assert(false && "Missing operand for function");
                double a = stack.top(); stack.pop();
                if (tok.keyword() == Keyword::POW) stack.push(pow(a, b));
                else if (tok.keyword() == Keyword::ATAN2) stack.push(atan2(a, b));
                else if (tok.keyword() == Keyword::FMOD) stack.push(fmod(a, b));
            }
            else {
                if (tok.keyword() == Keyword::SIN) stack.push(sin(b));
                else if (tok.keyword() == Keyword::COS) stack.push(cos(b));
                else if (tok.keyword() == Keyword::TAN) stack.push(tan(b));
                else if (tok.keyword() == Keyword::ASIN) stack.push(asin(b));
                else if (tok.keyword() == Keyword::ACOS) stack.push(acos(b));
                else if (tok.keyword() == Keyword::ATAN) stack.push(atan(b));
                else if (tok.keyword() == Keyword::SINH) stack.push(sinh(b));
                else if (tok.keyword() == Keyword::COSH) stack.push(cosh(b));
                else if (tok.keyword() == Keyword::TANH) stack.push(tanh(b));
                else if (tok.keyword() == Keyword::EXP) stack.push(exp(b));
                else if (tok.keyword() == Keyword::LOG) stack.push(log(b));
                else if (tok.keyword() == Keyword::LOG10) stack.push(log10(b));
                else if (tok.keyword() == Keyword::SQRT) stack.push(sqrt(b));
                else if (tok.keyword() == Keyword::CEIL) stack.push(ceil(b));
                else if (tok.keyword() == Keyword::FLOOR) stack.push(floor(b));
                else if (tok.keyword() == Keyword::FABS) stack.push(fabs(b));
                else if (tok.keyword() == Keyword::ROUND) stack.push(round(b));
                else if (tok.keyword() == Keyword::TRUNC) stack.push(trunc(b));
                else assert(false && "Unsupported math function");
            }
            break;
        }

        default:
            assert(false && "Unsupported token type in RPN");
        }
    }

    if (stack.size() != 1) assert(false && "Invalid expression evaluation");
    return stack.top();
}

bool FloatExpr::to_rpn(Scanner& in) {
    stack<Token> op_stack;
    int open_parens = 0;

    while (!in.peek().is_end()) {
        const Token& tok = in.peek();
        switch (tok.ttype()) {
        case TType::FLOAT:
            m_postfix.push_back(tok);
            in.next();
            break;

        case TType::IDENT:
            if (math_functions.count(tok.keyword()) > 0) {
                op_stack.push(tok); // function name
                in.next();
            }
            else {
                g_error->error_illegal_identifier(::to_string(tok.keyword()));
                clear();
                return false;
            }
            break;

        case TType::COMMA:
            if (open_parens < 1)
                break;
            in.next();
            while (!op_stack.empty() && op_stack.top().ttype() != TType::LPAREN) {
                m_postfix.push_back(op_stack.top());
                op_stack.pop();
            }
            if (op_stack.empty()) {
                g_error->error_unbalanced_parens();
                clear();
                return false;
            }
            break;

        case TType::OPERATOR: {
            const Token& current = tok;
            in.next();
            while (!op_stack.empty() && op_stack.top().ttype() == TType::OPERATOR) {
                Operator o1 = current.operator_();
                Operator o2 = op_stack.top().operator_();
                if ((is_right_associative(o1) && precedence(o1) < precedence(o2)) ||
                    (!is_right_associative(o1) && precedence(o1) <= precedence(o2))) {
                    m_postfix.push_back(op_stack.top());
                    op_stack.pop();
                }
                else {
                    break;
                }
            }
            op_stack.push(current);
            break;
        }

        case TType::LPAREN:
            ++open_parens;
            op_stack.push(tok);
            in.next();
            break;

        case TType::RPAREN:
            if (open_parens < 1)
                break;
            --open_parens;
            in.next();
            while (!op_stack.empty() && op_stack.top().ttype() != TType::LPAREN) {
                m_postfix.push_back(op_stack.top());
                op_stack.pop();
            }
            if (op_stack.empty()) {
				g_error->error_unbalanced_parens();
                clear();
				return false;
            }
            op_stack.pop();
            if (!op_stack.empty() && op_stack.top().ttype() == TType::IDENT) {
                m_postfix.push_back(op_stack.top());
                op_stack.pop();
            }
            break;

        default:
            break;  // end of expression
        }
    }

    while (!op_stack.empty()) {
        if (op_stack.top().ttype() == TType::LPAREN || op_stack.top().ttype() == TType::RPAREN) {
            g_error->error_unbalanced_parens();
            clear();
            return false;
        }
        m_postfix.push_back(op_stack.top());
        op_stack.pop();
    }

    return true;
}

int FloatExpr::precedence(Operator op) {
	const OperatorInfo* info = OperatorTable::get_info(op);
	assert(info && "Invalid operator");
	return info->precedence;
}

bool FloatExpr::is_right_associative(Operator op) {
    const OperatorInfo* info = OperatorTable::get_info(op);
    assert(info && "Invalid operator");
	return info->associativity == Associativity::Right;
}

#ifdef UNIT_TESTS
void FloatExpr::test() {
    auto token = [](TType ttype, double value = 0.0, Operator op = Operator::PLUS, Keyword keyword = Keyword::NONE) {
        if (ttype == TType::FLOAT) {
            Token token{ ttype, false };
            token.set_fvalue(value);
            return token;
        }
        else if (ttype == TType::OPERATOR) {
            Token token{ ttype, false };
            token.set_operator(op);
            return token;
        }
        else if (ttype == TType::IDENT) {
            Token token{ ttype, false };
            token.set_keyword(::to_string(keyword));
            return token;
        }
        else
            return Token(ttype, false);
        };

    auto test_case = [&](const vector<Token>& input, double expected) {
		FloatExpr expr;
        Scanner scanner{ input };
		assert(expr.parse(scanner));
        double result = expr.eval();
        assert(std::abs(result - expected) < 1e-9);
        };

    // Basic arithmetic tests
    test_case({ token(TType::FLOAT, 1), token(TType::OPERATOR, 0, Operator::PLUS), token(TType::FLOAT, 2) }, 3);
    test_case({ token(TType::FLOAT, 4), token(TType::OPERATOR, 0, Operator::MULT), token(TType::FLOAT, 2) }, 8);
    test_case({ token(TType::FLOAT, 2), token(TType::OPERATOR, 0, Operator::POWER), token(TType::FLOAT, 3) }, 8);

    // Unary functions
    test_case({ token(TType::IDENT, 0.0, Operator::PLUS, Keyword::SIN), token(TType::LPAREN), token(TType::FLOAT, 0), token(TType::RPAREN) }, sin(0));
    test_case({ token(TType::IDENT, 0.0, Operator::PLUS, Keyword::COS), token(TType::LPAREN), token(TType::FLOAT, 0), token(TType::RPAREN) }, cos(0));
    test_case({ token(TType::IDENT, 0.0, Operator::PLUS, Keyword::EXP), token(TType::LPAREN), token(TType::FLOAT, 1), token(TType::RPAREN) }, exp(1));
    test_case({ token(TType::IDENT, 0.0, Operator::PLUS, Keyword::LOG), token(TType::LPAREN), token(TType::FLOAT, 1), token(TType::RPAREN) }, log(1));
    test_case({ token(TType::IDENT, 0.0, Operator::PLUS, Keyword::SQRT), token(TType::LPAREN), token(TType::FLOAT, 4), token(TType::RPAREN) }, sqrt(4));
    test_case({ token(TType::IDENT, 0.0, Operator::PLUS, Keyword::FABS), token(TType::LPAREN), token(TType::FLOAT, -7.2), token(TType::RPAREN) }, fabs(-7.2));

    // Binary math functions
    test_case({
        token(TType::IDENT, 0.0, Operator::PLUS, Keyword::POW),token(TType::LPAREN),token(TType::FLOAT, 2),token(TType::COMMA),token(TType::FLOAT, 3),token(TType::RPAREN) }, 8);
    test_case({ token(TType::IDENT, 0.0, Operator::PLUS, Keyword::ATAN2),token(TType::LPAREN),token(TType::FLOAT, 0),
        token(TType::COMMA),token(TType::FLOAT, 1),token(TType::RPAREN) }, atan2(0, 1));
    test_case({ token(TType::IDENT, 0.0, Operator::PLUS, Keyword::FMOD),token(TType::LPAREN),token(TType::FLOAT, 7),token(TType::COMMA),token(TType::FLOAT, 3),token(TType::RPAREN) }, fmod(7, 3));

    // Precedence
    test_case({ token(TType::FLOAT, 2), token(TType::OPERATOR, 0, Operator::PLUS), token(TType::FLOAT, 3), token(TType::OPERATOR, 0, Operator::MULT), token(TType::FLOAT, 4) }, 2 + 3 * 4);
    test_case({ token(TType::FLOAT, 2), token(TType::OPERATOR, 0, Operator::MULT), token(TType::FLOAT, 3), token(TType::OPERATOR, 0, Operator::PLUS), token(TType::FLOAT, 4) }, 2 * 3 + 4);
    test_case({ token(TType::FLOAT, 2), token(TType::OPERATOR, 0, Operator::PLUS), token(TType::FLOAT, 3), token(TType::OPERATOR, 0, Operator::POWER), token(TType::FLOAT, 2) }, 2 + pow(3, 2));


    std::cout << "FloatExpr tests passed.\n";
}
#endif
