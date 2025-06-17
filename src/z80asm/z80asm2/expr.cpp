//-----------------------------------------------------------------------------
// z80asm
// Expression
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "expr.h"
#include "obj_module.h"
#include "symbol.h"
#include <cassert>
#include <stack>
using namespace std;

void Expr::clear() {
    m_infix.clear();
    m_postfix.clear();
    m_pos0 = 0;
}

bool Expr::parse(const string& line) {
    Scanner in;
    if (!in.scan(line)) {
        clear();
        return false;   // scan failed
    }
    else if (!parse(in, false)) {
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

bool Expr::parse(Scanner& in, bool silent) {
    clear();
    m_pos0 = in.pos();

    if (to_RPN(in, silent)) {
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

string Expr::to_string() const {
    Scanner tokens{ m_infix };
    return tokens.to_string();
}

string Expr::rpn_to_string() const {
    string output;
    for (auto& token : m_postfix) {
        output += token.to_string() + " ";
    }
    return output;
}

Expr* Expr::clone() const {
    auto new_expr = new Expr;
    new_expr->m_infix = m_infix;
    new_expr->m_postfix = m_postfix;
    new_expr->m_pos0 = m_pos0;
    return new_expr;
}

bool Expr::is_unary(Scanner& in) const {
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
bool Expr::to_RPN(Scanner& in, bool silent) {
    stack<Token> op_stack;

    while (!in.peek().is(TType::END)) {
        const Token& token = in.peek();
        TType ttype = token.ttype();
        Operator op = token.operator_();

        if (ttype == TType::INT || ttype == TType::IDENT || ttype == TType::ASMPC) {
            m_postfix.push_back(token);
            in.next();
        }
        else if (ttype == TType::OPERATOR) {

            // Adjust to unary operator
            if (is_unary(in)) {
                switch (op) {
                case Operator::PLUS: op = Operator::UPLUS; break;
                case Operator::MINUS: op = Operator::UMINUS; break;
                default:;
                }
            }

            while (!op_stack.empty()) {
                const Token& top = op_stack.top();
                if (top.ttype() != TType::OPERATOR)
                    break;
                Operator top_op = top.operator_();

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
            while (!op_stack.empty() && op_stack.top().ttype() != TType::LPAREN) {
                m_postfix.push_back(op_stack.top());
                op_stack.pop();
            }
            if (op_stack.empty()) {
                if (!silent) 
                    g_error->error_unbalanced_parens();
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
            while (!op_stack.empty() && op_stack.top().ttype() != TType::QUEST) {
                m_postfix.push_back(op_stack.top());
                op_stack.pop();
            }
            if (op_stack.empty()) {
                if (!silent) 
                    g_error->error_mismatched_ternary();
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
        if (op_stack.top().ttype() == TType::LPAREN || op_stack.top().ttype() == TType::RPAREN) {
            if (!silent)
                g_error->error_unbalanced_parens();
            return false;
        }
        m_postfix.push_back(op_stack.top());
        op_stack.pop();
    }

    if (m_postfix.empty()) {
        if (!silent)
            g_error->error_insufficient_operands(to_string());
        return false;   // no tokens
    }
    else {
        return check_syntax(silent);
    }
}

// check if all arguments to all operators were given
bool Expr::check_syntax(bool silent) {
    stack<int> eval_stack;
    for (auto& token : m_postfix) {
        TType ttype = token.ttype();

        if (ttype == TType::INT || ttype == TType::IDENT || ttype == TType::ASMPC) {
            eval_stack.push(1); // dummy value
        }
        else if (ttype == TType::OPERATOR) {
            const OperatorInfo& info = OperatorTable::get_info(token.operator_());

            size_t required = 0;
            switch (info.arity) {
            case Arity::Unary: required = 1; break;
            case Arity::Binary: required = 2; break;
            case Arity::Ternary: required = 3; break;
            }

            if (eval_stack.size() < required) {
                if (!silent)
                    g_error->error_insufficient_operands(::to_string(token.operator_()));
                return false;
            }

            // Pop required operands and push result
            for (size_t i = 0; i < required; ++i)
                eval_stack.pop();
            eval_stack.push(1);
        }
    }

    if (eval_stack.size() == 0) {
        if (!silent)
            g_error->error_insufficient_operands(to_string());
        return false;   // no tokens
    }
    else if (eval_stack.size() > 1) {
        if (!silent)
            g_error->error_extra_operands(to_string());
        return false;
    }
    else {
        return true;
    }
}

bool Expr::eval_const(Symtab* symtab, int& result) {
    stack<int> eval_stack;
    result = 0;
    Symbol* symbol{ nullptr };

    for (auto& token : m_postfix) {
        switch (token.ttype()) {
        case TType::INT:
            eval_stack.push(token.ivalue());
            break;

        case TType::IDENT:
            symbol = symtab->get_symbol(token.svalue());
            if (!symbol)
                return false;       // symbol not defined
            switch (symbol->sym_type()) {
            case SymType::UNDEFINED:
                return false;       // symbol not defined
            case SymType::CONSTANT:
                eval_stack.push(symbol->value());
                break;
            case SymType::ADDRESS:
                return false;       // value known only at link time
            case SymType::COMPUTED:
                return false;       // value known only at link time
            default:
                assert(false && "Unknown symbol type");
            }
            break;

        case TType::ASMPC:
            return false;           // value known only at link time
            break;

        case TType::OPERATOR:
            do_operator(token.operator_(), eval_stack);
            break;

        default:
            assert(false && "Unknown token type");
        }
    }

    if (eval_stack.size() > 1) {
        g_error->error_extra_operands(to_string());
        return false;   // too many operands
    }
    else if (eval_stack.size() == 0) {
        g_error->error_insufficient_operands(to_string());
        return false;   // no operands
    }
    else {
        result = eval_stack.top();
        eval_stack.pop();
        return true;
    }   
}

bool Expr::eval_instr(Symtab* symtab, Instr* asmpc, Instr*& result) {
    stack<Instr*> eval_stack;
    result = 0;
    Symbol* symbol{ nullptr };

    for (auto& token : m_postfix) {
        switch (token.ttype()) {
        case TType::INT:
            return false;

        case TType::IDENT:
            symbol = symtab->get_symbol(token.svalue());
            if (!symbol) 
                return false;
            
            switch (symbol->sym_type()) {
            case SymType::UNDEFINED:
                return false;
            case SymType::CONSTANT:
                return false;
            case SymType::ADDRESS:
                eval_stack.push(symbol->instr());
                break;
            case SymType::COMPUTED:
                return false;
            default:
                assert(false && "Unknown symbol type");
            }
            break;

        case TType::ASMPC:
            eval_stack.push(asmpc);
            break;

        case TType::OPERATOR:
            if (token.operator_() == Operator::UPLUS)
                break;
            else
                return false;

        default:
            assert(false && "Unknown token type");
        }
    }

    if (eval_stack.size() > 1) {
        return false;   // too many operands
    }
    else if (eval_stack.size() == 0) {
        return false;   // no operands
    }
    else {
        result = eval_stack.top();
        eval_stack.pop();
        return true;
    }
}

bool Expr::eval(Symtab* symtab, int asmpc, int& result, bool silent) {
    stack<int> eval_stack;
    result = 0;
    Symbol* symbol{ nullptr };

    for (auto& token : m_postfix) {
        switch (token.ttype()) {
        case TType::INT:
            eval_stack.push(token.ivalue());
            break;

        case TType::IDENT:
            symbol = symtab->get_symbol(token.svalue());
            if (!symbol) {
                if (!silent)
                    g_error->error_undefined_symbol(token.svalue());
                return false;
            }
            switch (symbol->sym_type()) {
            case SymType::UNDEFINED:
                if (!silent)
                    g_error->error_undefined_symbol(token.svalue());
                return false;
            case SymType::CONSTANT:
                eval_stack.push(symbol->value());
                break;
            case SymType::ADDRESS:
                eval_stack.push(symbol->instr()->offset());
                break;
            case SymType::COMPUTED:
                if (symbol->in_eval()) {
                    if (!silent)
                        g_error->error_recursive_evaluation(symbol->name());
                    return false;   // recursive expression
                }
                symbol->set_in_eval(true);
                {
                    int sub_result = 0;
                    if (!symbol->expr()->eval(symtab, asmpc,
                        sub_result, silent))
                        return false;   // evaluation failed
                    eval_stack.push(sub_result);
                }
                symbol->set_in_eval(false);
                break;
            default:
                assert(false && "Unknown symbol type");
            }
            break;

        case TType::ASMPC:
            eval_stack.push(asmpc);
            break;

        case TType::OPERATOR:
            do_operator(token.operator_(), eval_stack);
            break;

        default:
            assert(false && "Unknown token type");
        }
    }

    if (eval_stack.size() > 1) {
        if (!silent)
            g_error->error_extra_operands(to_string());
        return false;   // too many operands
    }
    else if (eval_stack.size() == 0) {
        if (!silent)
            g_error->error_insufficient_operands(to_string());
        return false;   // no operands
    }
    else {
        result = eval_stack.top();
        eval_stack.pop();
        return true;
    }
}

