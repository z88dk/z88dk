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
    stack<double> stack;

    for (const Token& tok : m_postfix) {
        switch (tok.ttype()) {
        case TType::FLOAT:
            stack.push(tok.fvalue());
            break;

        case TType::OPERATOR: 
			do_operator(tok.op(), stack);
            break;

        case TType::IDENT: 
            do_function(tok.keyword(), stack);
            break;

        default:
            assert(false && "Unsupported token type in RPN");
        }
    }

    assert(stack.size() == 1 && "Invalid expression evaluation");
    return stack.top();
}

bool FloatExpr::is_unary(Scanner& in) const {
    if (in.pos() == m_pos0)
        return true;
    const Token& prev = in.peek(-1);
    switch (prev.ttype()) {
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
bool FloatExpr::to_rpn(Scanner& in) {
    stack<Token> op_stack;
    int open_parens = 0;

    bool end_of_expr = false;
    while (!in.peek().is(TType::END) && !end_of_expr) {
        const Token& tok = in.peek();
        Operator op = tok.op();

        switch (tok.ttype()) {
        case TType::INT: {
            Token push_tok{ TType::FLOAT, false };
            push_tok.set_fvalue(static_cast<double>(tok.ivalue()));
            m_postfix.push_back(push_tok);
            in.next();
            break;
        }
        case TType::FLOAT:
            m_postfix.push_back(tok);
            in.next();
            break;

        case TType::OPERATOR: {
            // Adjust to unary operator
            if (is_unary(in)) {
                switch (op) {
                case Operator::PLUS: op = Operator::UNARY_PLUS; break;
                case Operator::MINUS: op = Operator::UNARY_MINUS; break;
                default:;
                }
            }

            while (!op_stack.empty()) {
                const Token& top = op_stack.top();
                if (top.ttype() != TType::OPERATOR)
                    break;
                Operator top_op = top.op();

                const OperatorInfo* op1 = OperatorTable::get_info(op);
                const OperatorInfo* op2 = OperatorTable::get_info(top_op);

                if ((op1->associativity == Associativity::Left && op1->precedence <= op2->precedence) ||
                    (op1->associativity == Associativity::Right && op1->precedence < op2->precedence)) {
                    m_postfix.push_back(top);
                    op_stack.pop();
                }
                else {
                    break;
                }
            }

            // Push operator (mark unary ops explicitly)
            Token push_op = tok;
            push_op.set_operator(op);       // set unary operator
            op_stack.push(push_op);
            in.next();
            break;
        }

        case TType::IDENT: {
            const FunctionInfo* info = FunctionTable::get_info(tok.keyword());
            if (!info) {
                g_error->error_illegal_identifier(::to_string(tok.keyword()));
                return false;
            }
            else {
                op_stack.push(tok); // function
                in.next();
            }
            break;
        }
        case TType::LPAREN:
            ++open_parens;
            op_stack.push(tok);
            in.next();
            break;

        case TType::RPAREN:
            if (open_parens < 1) {
                end_of_expr = true;
            }
            else {
                --open_parens;
                while (!op_stack.empty() && op_stack.top().ttype() != TType::LPAREN) {
                    m_postfix.push_back(op_stack.top());
                    op_stack.pop();
                }
                if (op_stack.empty()) {
                    g_error->error_unbalanced_parens();
                    return false;
                }
                op_stack.pop(); // pop '('
                in.next();
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
                return false;
            }
            break;

        case TType::QUEST:
            op_stack.push(tok);
            in.next();
            break;

        case TType::COLON: {
            while (!op_stack.empty() && op_stack.top().ttype() != TType::QUEST) {
                m_postfix.push_back(op_stack.top());
                op_stack.pop();
            }
            if (op_stack.empty()) {
                g_error->error_mismatched_ternary();
                return false;
            }
            op_stack.pop(); // Pop '?'

            Token push_op{ TType::OPERATOR, false };
            push_op.set_operator(Operator::TERNARY);
            op_stack.push(push_op);
            in.next();
            break;
        }
        default:
            end_of_expr = true; // end of expression
            break;
        }
    }

    while (!op_stack.empty()) {
        if (op_stack.top().ttype() == TType::LPAREN || op_stack.top().ttype() == TType::RPAREN) {
            g_error->error_unbalanced_parens();
            return false;
        }
        m_postfix.push_back(op_stack.top());
        op_stack.pop();
    }

    if (m_postfix.empty()) {
        g_error->error_insufficient_operands(to_string());
        return false;   // no tokens
    }
    else {
        return check_RPN_syntax();
    }
}

bool FloatExpr::check_RPN_syntax() {
    stack<double> stack;
    for (auto& tok : m_postfix) {
        switch (tok.ttype()) {
        case TType::FLOAT:
            stack.push(1.0); // dummy value
            break;

        case TType::OPERATOR: {
            const OperatorInfo* info = OperatorTable::get_info(tok.op());

            size_t required = 0;
            switch (info->arity) {
            case Arity::Unary: required = 1; break;
            case Arity::Binary: required = 2; break;
            case Arity::Ternary: required = 3; break;
            }

            if (stack.size() < required) {
                g_error->error_insufficient_operands(::to_string(tok.op()));
                return false;
            }

            // Pop required operands and push result
            for (size_t i = 0; i < required; ++i)
                stack.pop();
            stack.push(1.0);
            break;
        }
        case TType::IDENT: {
            const FunctionInfo* info = FunctionTable::get_info(tok.keyword());
            assert(info && "Invalid function identifier");

            size_t required = 0;
            switch (info->arity) {
            case Arity::Unary: required = 1; break;
            case Arity::Binary: required = 2; break;
            case Arity::Ternary: required = 3; break;
            }

            if (stack.size() < required) {
                g_error->error_insufficient_operands(::to_string(tok.op()));
                return false;
            }

            // Pop required operands and push result
            for (size_t i = 0; i < required; ++i)
                stack.pop();
            stack.push(1.0);
            break;
        }
        default:
            assert(false && "Unknown token type in RPN syntax check");
        }
    }

    if (stack.size() == 0) {
        g_error->error_insufficient_operands(to_string());
        return false;   // no tokens
    }
    else if (stack.size() > 1) {
        g_error->error_extra_operands(to_string());
        return false;
    }
    else {
        return true;
    }
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

string FloatExpr::to_string() const {
    Scanner tokens{ m_infix };
    return tokens.to_string();
}

string FloatExpr::rpn_to_string() const {
    string output;
    for (auto& token : m_postfix) {
        if (token.op() == Operator::UNARY_PLUS ||
            token.op() == Operator::UNARY_MINUS)
            output += "u";
        output += token.to_string() + " ";
    }
    return output;
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
        assert(abs(result - expected) < 1e-9);
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


    cout << "FloatExpr tests passed.\n";
}
#endif
