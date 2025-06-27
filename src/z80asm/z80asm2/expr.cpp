//-----------------------------------------------------------------------------
// z80asm
// Expression
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "error.h"
#include "expr.h"
#include "obj_module.h"
#include "symbol.h"
#include <cassert>
#include <stack>
using namespace std;

Expr::Expr()
    : m_location(*g_location)
    , m_asmpc(g_obj_module->cur_section()->asmpc()) {
}

void Expr::clear() {
    m_infix.clear();
    m_postfix.clear();
    m_pos0 = 0;
    m_location = *g_location;
    m_asmpc = g_obj_module->cur_section()->asmpc();
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

void Expr::lookup_symbols() {
    Symtab* symtab = g_obj_module->symtab();
    Symbol* symbol = nullptr;
    m_asmpc = g_obj_module->cur_section()->asmpc();
    
    for (auto& token : m_postfix) {
        switch (token.ttype()) {
        case TType::IDENT:
            symbol = symtab->touch_symbol(token.svalue());
            token.set_symbol(symbol);
            break;
        default:;
        }
    }
}

string Expr::to_string() const {
    Scanner tokens{ m_infix };
    return tokens.to_string();
}

string Expr::rpn_to_string() const {
    string output;
    for (auto& token : m_postfix) {
        if (token.operator_() == Operator::UPLUS ||
            token.operator_() == Operator::UMINUS)
            output += "u";
        output += token.to_string() + " ";
    }
    return output;
}

Expr* Expr::clone() const {
    auto new_expr = new Expr;
    new_expr->m_infix = m_infix;
    new_expr->m_postfix = m_postfix;
    new_expr->m_pos0 = m_pos0;
    new_expr->m_location = m_location;
    return new_expr;
}

Expr::Result Expr::combine_results(Result r1) const {
    if (r1 == Result::Undefined)
        return Result::Undefined;
    if (r1 == Result::Constant)
        return Result::Constant;
    return Result::Computed;
}

Expr::Result Expr::combine_results(Result r1, Result r2) const {
    if (r1 == Result::Undefined || r2 == Result::Undefined)
        return Result::Undefined;
    if (r1 == Result::Constant && r2 == Result::Constant)
        return Result::Constant;
    return Result::Computed;
}

Expr::Result Expr::combine_results(Result r1, Result r2, Result r3) const {
    if (r1 == Result::Undefined || r2 == Result::Undefined || r3 == Result::Undefined)
        return Result::Undefined;
    if (r1 == Result::Constant && r2 == Result::Constant && r3 == Result::Constant)
        return Result::Constant;
    return Result::Computed;
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
    int open_parens = 0;

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
            Token push_op = token;
            push_op.set_operator(op);       // set unary operator
            op_stack.push(push_op);
            in.next();
        }
        else if (ttype == TType::LPAREN) {
            ++open_parens;
            op_stack.push(token);
            in.next();
        }
        else if (ttype == TType::RPAREN) {
            if (open_parens < 1)
                break;
            --open_parens;
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
        return check_RPN_syntax(silent);
    }
}

// check if all arguments to all operators were given
bool Expr::check_RPN_syntax(bool silent) {
    stack<int> eval_stack;
    for (auto& token : m_postfix) {
        TType ttype = token.ttype();

        if (ttype == TType::INT || ttype == TType::IDENT || ttype == TType::ASMPC) {
            eval_stack.push(1); // dummy value
        }
        else if (ttype == TType::OPERATOR) {
            const OperatorInfo* info = OperatorTable::get_info(token.operator_());

            size_t required = 0;
            switch (info->arity) {
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

Expr::ValueResult Expr::check_eval() const {
    stack<ValueResult> operands;
    Symbol* symbol{ nullptr };
    const OperatorInfo* op_info{ nullptr };
    ValueResult x1, x2, x3, r;

    for (auto& token : m_postfix) {
        switch (token.ttype()) {
        case TType::INT:
            operands.push(ValueResult(token.ivalue(), Result::Constant));
            break;

        case TType::IDENT:
            symbol = token.symbol();
            if (!symbol) {
                operands.push(ValueResult(0, Result::Undefined));
            }
            else {
                switch (symbol->sym_type()) {
                case SymType::UNDEFINED:
                    operands.push(ValueResult(0, Result::Undefined));
                    break;

                case SymType::CONSTANT:
                    operands.push(ValueResult(symbol->value(), Result::Constant));
                    break;

                case SymType::ADDRESS:
                    if (g_assembler->pass() != Assembler::Pass::PASS2) {
                        operands.push(ValueResult(0, Result::Undefined));
                    }
                    else {
                        operands.push(ValueResult(symbol->instr()->offset(),
                            Result::Address,
                            symbol->instr()->parent(),
                            symbol->instr()));
                    }
                    break;

                case SymType::COMPUTED:
                    if (symbol->in_eval()) {
                        g_error->error_recursive_evaluation(symbol->name());
                        return ValueResult(0, Result::Undefined);   // recursive expression
                    }
                    symbol->set_in_eval(true);
                    {
                        ValueResult sub_result = symbol->expr()->check_eval();
                        operands.push(sub_result);
                    }
                    symbol->set_in_eval(false);
                    break;

                default:
                    assert(false && "Unknown symbol type");
                }

            }
            break;

        case TType::ASMPC:
            if (g_assembler->pass() != Assembler::Pass::PASS2) {
                operands.push(ValueResult(0, Result::Undefined));
            }
            else {
                operands.push(ValueResult(m_asmpc->offset(),
                    Result::Address,
                    m_asmpc->parent(),
                    m_asmpc));
            }
            break;

        case TType::OPERATOR:
            // get operands
            op_info = OperatorTable::get_info(token.operator_());
            switch (op_info->arity) {
            case Arity::Unary:
                if (operands.size() < 1) {
                    g_error->error_insufficient_operands(::to_string(token.operator_()));
                    return ValueResult(0, Result::Undefined);
                }
                x1 = operands.top(); operands.pop();
                break;

            case Arity::Binary:
                if (operands.size() < 2) {
                    g_error->error_insufficient_operands(::to_string(token.operator_()));
                    return ValueResult(0, Result::Undefined);
                }
                x2 = operands.top(); operands.pop();
                x1 = operands.top(); operands.pop();
                break;

            case Arity::Ternary:
                if (operands.size() < 3) {
                    g_error->error_insufficient_operands(::to_string(token.operator_()));
                    return ValueResult(0, Result::Undefined);
                }
                x3 = operands.top(); operands.pop();
                x2 = operands.top(); operands.pop();
                x1 = operands.top(); operands.pop();
                break;

            default:
                assert(false && "Unknown operator arity");
            }

            // compute result
            r = ValueResult();
            switch (token.operator_()) {
            case Operator::POWER:
                if (x1 == ValueResult(0, Result::Constant) &&
                    x2.value > 0 && x2.result == Result::Constant) {
                    r.value = 0;
                    r.result = Result::Constant;
					r.section = nullptr;
                    r.instr = nullptr;
                }
                else if (x1 == ValueResult(1, Result::Constant) ||
                    x2 == ValueResult(0, Result::Constant)) {
                    r.value = 1;
                    r.result = Result::Constant;
					r.section = nullptr;
                    r.instr = nullptr;
                }
                else {
                    r.value = ipow(x1.value, x2.value);
                    r.result = combine_results(x1.result, x2.result);
					r.section = nullptr;
                    r.instr = nullptr;
                }
                break;

            case Operator::UPLUS:
                r = x1;
                break;

            case Operator::UMINUS:
                r.value = -x1.value;
                r.result = x1.result;
				r.section = x1.section;
                r.instr = x1.instr;
                break;

            case Operator::LOG_NOT:
                r.value = (x1.value == 0) ? 1 : 0;
                r.result = combine_results(x1.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::BIN_NOT:
                r.value = ~x1.value;
                r.result = x1.result;
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::MULT:
                if (x1 == ValueResult(0, Result::Constant)) {
                    r.value = 0;
                    r.result = Result::Constant;
					r.section = nullptr;
                    r.instr = nullptr;
                }
                else if (x2 == ValueResult(0, Result::Constant)) {
                    r.value = 0;
                    r.result = Result::Constant;
					r.section = nullptr;
                    r.instr = nullptr;
                }
                else if (x1 == ValueResult(1, Result::Constant)) {
                    r.value = x2.value;
                    r.result = x2.result;
					r.section = x2.section;
                    r.instr = x2.instr;
                }
                else if (x2 == ValueResult(1, Result::Constant)) {
                    r.value = x1.value;
                    r.result = x1.result;
					r.section = x1.section;
                    r.instr = x1.instr;
                }
                else {
                    r.value = x1.value * x2.value;
                    r.result = combine_results(x1.result, x2.result);
					r.section = nullptr;
                    r.instr = nullptr;
                }
                break;

            case Operator::DIV:
                if (x2 == ValueResult(0, Result::Constant)) {
                    g_error->error_division_by_zero();
                    return ValueResult(0, Result::Undefined);
                }
                else if (x2 == ValueResult(1, Result::Constant)) {
                    r.value = x1.value;
                    r.result = x1.result;
					r.section = x1.section;
                    r.instr = x1.instr;
                }
                else if (x1 == x2) {
                    r.value = 1;
                    r.result = (x1.result == Result::Undefined) ? Result::Undefined : Result::Constant;
                    r.section = x1.section;
                    r.instr = x1.instr;
                }
                else {
                    r.value = x1.value / x2.value;
                    r.result = combine_results(x1.result, x2.result);
					r.section = nullptr;
                    r.instr = nullptr;
                }
                break;

            case Operator::MOD:
                if (x2 == ValueResult(0, Result::Constant)) {
                    g_error->error_division_by_zero();
                    return ValueResult(0, Result::Undefined);
                }
                else if (x1 == x2) {
                    r.value = 0;
                    r.result = (x1.result == Result::Undefined) ? Result::Undefined : Result::Constant;
                    r.section = x1.section;
                    r.instr = x1.instr;
                }
                else {
                    r.value = x1.value % x2.value;
                    r.result = combine_results(x1.result, x2.result);
					r.section = nullptr;
                    r.instr = nullptr;
                }
                break;

            case Operator::PLUS:
                if (x1 == ValueResult(0, Result::Constant)) {
                    r.value = x2.value;
                    r.result = x2.result;
					r.section = x2.section;
                    r.instr = x2.instr;
                }
                else if (x2 == ValueResult(0, Result::Constant)) {
                    r.value = x1.value;
                    r.result = x1.result;
					r.section = x1.section;
                    r.instr = x1.instr;
                }
                else if (different_sign(x1.value, x2.value) &&
                    x1.result == Result::Address && x2.result == Result::Address &&
                    x1.section == x2.section) {
                    r.value = x1.value + x2.value;
                    r.result = Result::Constant;
					r.section = nullptr;
                    r.instr = nullptr;
                }
                else {
                    r.value = x1.value + x2.value;
                    r.result = combine_results(x1.result, x2.result);
					r.section = nullptr;
                    r.instr = nullptr;
                }
                break;

            case Operator::MINUS:
                if (x1 == ValueResult(0, Result::Constant)) {
                    r.value = -x2.value;
                    r.result = x2.result;
					r.section = x2.section;
                    r.instr = x2.instr;
                }
                else if (x2 == ValueResult(0, Result::Constant)) {
                    r.value = x1.value;
                    r.result = x1.result;
					r.section = x1.section;
                    r.instr = x1.instr;
                }
                else if (different_sign(x1.value, -x2.value) &&
                    x1.result == Result::Address && x2.result == Result::Address &&
                    x1.section == x2.section) {
                    r.value = x1.value - x2.value;
                    r.result = Result::Constant;
					r.section = nullptr;
                    r.instr = nullptr;
                }
                else {
                    r.value = x1.value - x2.value;
                    r.result = combine_results(x1.result, x2.result);
					r.section = nullptr;
                    r.instr = nullptr;
                }
                break;

            case Operator::LSHIFT:
                r.value = x1.value << x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::RSHIFT:
                r.value = x1.value >> x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::LT:
                r.value = x1.value < x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::LE:
                r.value = x1.value <= x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::GT:
                r.value = x1.value > x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::GE:
                r.value = x1.value >= x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::EQ:
                r.value = x1.value == x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::NE:
                r.value = x1.value != x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::BIN_AND:
                r.value = x1.value & x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::BIN_OR:
                r.value = x1.value | x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::BIN_XOR:
                r.value = x1.value ^ x2.value;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::LOG_AND:
                r.value = (x1.value && x2.value) ? 1 : 0;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::LOG_OR:
                r.value = (x1.value || x2.value) ? 1 : 0;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::LOG_XOR:
                r.value = (x1.value != x2.value) ? 1 : 0;
                r.result = combine_results(x1.result, x2.result);
				r.section = nullptr;
                r.instr = nullptr;
                break;

            case Operator::TERNARY:
                if (x1.result == Result::Undefined) {
                    r.value = 0;
                    r.result = Result::Undefined;
                    r.section = nullptr;
                    r.instr = nullptr;
                }
                else if (x1.result == Result::Constant) {
                    if (x1.value) {
                        r = x2;
                    }
                    else {
                        r = x3;
                    }
                }
                else {
                    r.value = x1.value ? x2.value : x3.value;
                    r.result = combine_results(x1.result, x2.result, x3.result);
                    r.section = nullptr;
                    r.instr = nullptr;
                }
                break;

            default:
                assert(false && "Unknown operator");
            }
            operands.push(r);
            break;

        default:
            assert(false && "Unknown token type");
        }
    }

    if (operands.size() > 1) {
        g_error->error_extra_operands(to_string());
        return ValueResult(0, Result::Undefined);
    }
    else if (operands.size() == 0) {
        g_error->error_insufficient_operands(to_string());
        return ValueResult(0, Result::Undefined);
    }
    else {
        r = operands.top(); operands.pop();
        return r;
    }
}

bool Expr::eval_const(int& value) {
    ValueResult r = check_eval();
    if (r.result == Result::Constant) {
        value = r.value;
        return true;
    }
    else {
        return false;
    }
}

bool Expr::eval_instr(Instr*& instr) {
    ValueResult r = check_eval();
    if (r.result == Result::Address && r.instr != nullptr) {
        instr = r.instr;
        return true;
    }
    else {
        return false;
    }
}

bool Expr::eval(int& result, bool silent) {
    stack<int> eval_stack;
    result = 0;
    Symbol* symbol{ nullptr };

    for (auto& token : m_postfix) {
        switch (token.ttype()) {
        case TType::INT:
            eval_stack.push(token.ivalue());
            break;

        case TType::IDENT:
            symbol = token.symbol();
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
                    if (!symbol->expr()->eval(sub_result, silent))
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
            eval_stack.push(m_asmpc->offset());
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

bool Expr::eval_local_jr_distance(int& distance) {
    ValueResult r = check_eval();
    if (r.result == Result::Address &&      // target must be address
        r.section == m_asmpc->parent()) {   // in the same section
        int base = m_asmpc->offset() + m_asmpc->size();
        distance = r.value - base;
        return true;
    }
    else {
        return false;
    }
}

#ifdef UNIT_TESTS
void Expr::test() {
    Expr* e1 = new Expr;
    Scanner in;
    int value;
    Instr* instr = nullptr;
    ValueResult r;

    // unary operators at middle of input
    g_location->clear();
    in.scan("DEFB + 1 ");
    assert(in.peek().is(Keyword::DEFB));
    in.next();
    assert(in.peek().is(TType::OPERATOR) && in.peek().operator_() == Operator::PLUS);
    assert(e1->parse(in, true));
    assert(in.peek().is_end());
    assert(e1->eval_const(value));
    assert(value == 1);
    assert(e1->to_string() == "+1");
    assert(e1->rpn_to_string() == "1 u+ ");
    assert(e1->m_location.filename() == "");
    assert(e1->m_location.line_num() == 0);

    // expression inside parens
    g_location->clear();
    in.scan("( + 1 )");
    assert(in.peek().is(TType::LPAREN));
    in.next();
    assert(in.peek().is(TType::OPERATOR) && in.peek().operator_() == Operator::PLUS);
    assert(e1->parse(in, true));
    assert(in.peek().is(TType::RPAREN));
    in.next();
    assert(in.peek().is_end());
    assert(e1->eval_const(value));
    assert(value == 1);
    assert(e1->to_string() == "+1");
    assert(e1->rpn_to_string() == "1 u+ ");
    assert(e1->m_location.filename() == "");
    assert(e1->m_location.line_num() == 0);

    // expression inside parens
    g_location->clear();
    in.scan("( + 1 * ( 1 + 3 ) )");
    assert(in.peek().is(TType::LPAREN));
    in.next();
    assert(in.peek().is(TType::OPERATOR) && in.peek().operator_() == Operator::PLUS);
    assert(e1->parse(in, true));
    assert(in.peek().is(TType::RPAREN));
    in.next();
    assert(in.peek().is_end());
    assert(e1->eval_const(value));
    assert(value == 4);
    assert(e1->to_string() == "+1*(1+3)");
    assert(e1->rpn_to_string() == "1 u+ 1 3 + * ");
    assert(e1->m_location.filename() == "");
    assert(e1->m_location.line_num() == 0);

    // location
    g_location->set("test.asm", 10);
    in.scan(" 2 * 3 ");
    assert(e1->parse(in, true));
    assert(in.peek().is_end());
    assert(e1->eval_const(value));
    assert(value == 6);
    assert(e1->to_string() == "2*3");
    assert(e1->rpn_to_string() == "2 3 * ");
    assert(e1->m_location.filename() == "test.asm");
    assert(e1->m_location.line_num() == 10);

    // clone
    Expr* e2 = e1->clone();
    assert(e2->to_string() == e1->to_string());
    assert(e2->rpn_to_string() == e1->rpn_to_string());
    assert(e2->m_location.filename() == e1->m_location.filename());
    assert(e2->m_location.line_num() == e1->m_location.line_num());
    assert(e2->eval_const(value));
    assert(value == 6);
    delete e2;

    // parse line
    assert(e1->parse(" 4 + 5 "));
    assert(e1->to_string() == "4+5");
    assert(e1->rpn_to_string() == "4 5 + ");
    assert(e1->eval_const(value));
    assert(value == 9);
    assert(e1->m_location.filename() == "test.asm");
    assert(e1->m_location.line_num() == 10);

    // parse line with unary operator
    assert(e1->parse(" 6 - 7 "));
    assert(e1->to_string() == "6-7");
    assert(e1->rpn_to_string() == "6 7 - ");
    assert(e1->eval_const(value));
    assert(value == -1);
    assert(e1->m_location.filename() == "test.asm");
    assert(e1->m_location.line_num() == 10);

    // parse line with unary operator at start
    assert(e1->parse(" - 8 + 9 "));
    assert(e1->to_string() == "-8+9");
    assert(e1->rpn_to_string() == "8 u- 9 + ");
    assert(e1->eval_const(value));
    assert(value == 1);
    assert(e1->m_location.filename() == "test.asm");
    assert(e1->m_location.line_num() == 10);

    // parse line with unary operator at end
    assert(e1->parse(" 10 * - 11 "));
    assert(e1->to_string() == "10*-11");
    assert(e1->rpn_to_string() == "10 11 u- * ");
    assert(e1->eval_const(value));
    assert(value == -110);
    assert(e1->m_location.filename() == "test.asm");
    assert(e1->m_location.line_num() == 10);

    assert(e1->parse(" 10 * + 11 "));
    assert(e1->to_string() == "10*+11");
    assert(e1->rpn_to_string() == "10 11 u+ * ");
    assert(e1->eval_const(value));
    assert(value == 110);
    assert(e1->m_location.filename() == "test.asm");
    assert(e1->m_location.line_num() == 10);

    // check_eval
    g_assembler->clear();
    assert(e1->parse("42"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 42);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("xpto"));
    assert(!g_obj_module->symtab()->get_symbol("xpto"));
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(g_obj_module->symtab()->get_symbol("xpto"));
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    e2 = new Expr();
    assert(e2->parse("40+2"));
    g_obj_module->add_equ("xpto", e2->clone());
    delete e2;
    assert(g_obj_module->symtab()->get_symbol("xpto"));
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 42);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("xpto");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1+x2"));
    e1->lookup_symbols();
    g_obj_module->add_equ("x3", e1->clone());
    assert(e1->parse("x3"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 12);
    assert(r.result == Result::Computed);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 8);
    assert(r.result == Result::Address);

    g_assembler->clear();
    assert(e1->parse("0**123456789"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1**0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2**4"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 16);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("+4"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 4);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("+$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 8);
    assert(r.result == Result::Address);

    g_assembler->clear();
    assert(e1->parse("-4"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == -4);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Computed);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Computed);

    g_assembler->clear();
    assert(e1->parse("~123"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == ~123);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0*$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$*0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("1*$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 8);
    assert(r.result == Result::Address);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$*1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 8);
    assert(r.result == Result::Address);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$*2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 16);
    assert(r.result == Result::Computed);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 8);
    assert(r.result == Result::Address);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 4);
    assert(r.result == Result::Computed);

    g_assembler->clear();
    assert(e1->parse("4/2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 2);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$/$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$%$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$%$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("10%3"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 8);
    assert(r.result == Result::Address);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 8);
    assert(r.result == Result::Address);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("-x1+x2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("-x1+x2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 4);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 4);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->set_cur_section("code");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->set_cur_section("data");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x2");
    g_obj_module->set_cur_section("");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Computed);

    g_assembler->clear();
    g_obj_module->set_cur_section("code");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_obj_module->set_cur_section("");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 4);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1+x2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 12);
    assert(r.result == Result::Computed);

    g_assembler->clear();
    assert(e1->parse("10+3"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 13);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("x2-x2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x2-x1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 4);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("(0-x1)+x2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("(0-x1)+x2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 4);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0-x1+(x2-0)"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Undefined);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+(x2-0)"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 4);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("10-3"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 7);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1<<4"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 16);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("16>>4"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0<1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1<1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2<1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0<=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1<=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2<=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0>1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1>1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2>1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0>=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1>=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2>=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0==1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1==1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2==1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0!=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1!=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2!=1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0<>1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1<>1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2<>1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("-1&16"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 16);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("2|8"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 10);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("10^15"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 5);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0&&0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0&&1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1&&0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1&&1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0||0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0||1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1||0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1||1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0^^0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0^^1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1^^0"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 1);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1^^1"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 0);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("0?1:2"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 2);
    assert(r.result == Result::Constant);

    g_assembler->clear();
    assert(e1->parse("1?2:3"));
    e1->lookup_symbols();
    r = e1->check_eval();
    assert(r.value == 2);
    assert(r.result == Result::Constant);

    // eval_const
    g_assembler->clear();
    assert(e1->parse("42"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 42);

    g_assembler->clear();
    assert(e1->parse("xpto"));
    assert(!g_obj_module->symtab()->get_symbol("xpto"));
    assert(!e1->eval_const(value));

    g_assembler->clear();
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(g_obj_module->symtab()->get_symbol("xpto"));
    assert(!e1->eval_const(value));

    g_assembler->clear();
    e2 = new Expr();
    assert(e2->parse("40+2"));
    g_obj_module->add_equ("xpto", e2->clone());
    delete e2;
    assert(g_obj_module->symtab()->get_symbol("xpto"));
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 42);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("xpto");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1+x2"));
    e1->lookup_symbols();
    g_obj_module->add_equ("x3", e1->clone());
    assert(e1->parse("x3"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    assert(e1->parse("0**123456789"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("1**0"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("2**4"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 16);

    g_assembler->clear();
    assert(e1->parse("+4"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 4);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("+$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    assert(e1->parse("-4"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == -4);

    g_assembler->clear();
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    assert(e1->parse("~123"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == ~123);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0*$"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$*0"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("1*$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$*1"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$*2"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/1"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/2"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    assert(e1->parse("4/2"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 2);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$/$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/$"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$%$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$%$"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("10%3"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("-x1+x2"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 4);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 4);

    g_assembler->clear();
    g_obj_module->set_cur_section("code");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->set_cur_section("data");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x2");
    g_obj_module->set_cur_section("");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->set_cur_section("code");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_obj_module->set_cur_section("");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 4);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    assert(e1->parse("10+3"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 13);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("x2-x2"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x2-x1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 4);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("(0-x1)+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("(0-x1)+x2"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 4);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0-x1+(x2-0)"));
    e1->lookup_symbols();
    assert(!e1->eval_const(value));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+(x2-0)"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 4);

    g_assembler->clear();
    assert(e1->parse("10-3"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 7);

    g_assembler->clear();
    assert(e1->parse("1<<4"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 16);

    g_assembler->clear();
    assert(e1->parse("16>>4"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("0<1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("1<1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("2<1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("0<=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("1<=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("2<=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("0>1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("1>1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("2>1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("0>=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("1>=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("2>=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("0=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("1=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("2=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("0==1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("1==1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("2==1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("0!=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("1!=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("2!=1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("0<>1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("1<>1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("2<>1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("-1&16"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 16);

    g_assembler->clear();
    assert(e1->parse("2|8"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 10);

    g_assembler->clear();
    assert(e1->parse("10^15"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 5);

    g_assembler->clear();
    assert(e1->parse("0&&0"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("0&&1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("1&&0"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("1&&1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("0||0"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("0||1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("1||0"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("1||1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("0^^0"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("0^^1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("1^^0"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 1);

    g_assembler->clear();
    assert(e1->parse("1^^1"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 0);

    g_assembler->clear();
    assert(e1->parse("0?1:2"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 2);

    g_assembler->clear();
    assert(e1->parse("1?2:3"));
    e1->lookup_symbols();
    assert(e1->eval_const(value));
    assert(value == 2);

    // eval_instr
    g_assembler->clear();
    assert(e1->parse("42"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("xpto"));
    assert(!g_obj_module->symtab()->get_symbol("xpto"));
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(g_obj_module->symtab()->get_symbol("xpto"));
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    e2 = new Expr();
    assert(e2->parse("40+2"));
    g_obj_module->add_equ("xpto", e2->clone());
    delete e2;
    assert(g_obj_module->symtab()->get_symbol("xpto"));
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("xpto");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1+x2"));
    e1->lookup_symbols();
    g_obj_module->add_equ("x3", e1->clone());
    assert(e1->parse("x3"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("+$"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("1?$:0"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    assert(e1->parse("0**123456789"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1**0"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2**4"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("+4"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("+$"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    assert(e1->parse("-4"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("~123"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0*$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$*0"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("1*$"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$*1"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$*2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/1"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("4/2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$/$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$%$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$%$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("10%3"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->cur_section()->asmpc());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("x1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->symtab()->get_symbol("x1")->instr());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x2"));
    e1->lookup_symbols();
    assert(e1->eval_instr(instr));
    assert(instr == g_obj_module->symtab()->get_symbol("x2")->instr());

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->set_cur_section("code");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->set_cur_section("data");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x2");
    g_obj_module->set_cur_section("");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->set_cur_section("code");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_obj_module->set_cur_section("");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("10+3"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("x2-x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x2-x1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("(0-x1)+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("(0-x1)+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0-x1+(x2-0)"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+(x2-0)"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("10-3"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1<<4"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("16>>4"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0<1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1<1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2<1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0<=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1<=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2<=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0>1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1>1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2>1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0>=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1>=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2>=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0==1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1==1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2==1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0!=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1!=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2!=1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0<>1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1<>1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2<>1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("-1&16"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("2|8"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("10^15"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0&&0"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0&&1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1&&0"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1&&1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0||0"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0||1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1||0"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1||1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0^^0"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0^^1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1^^0"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1^^1"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("0?1:2"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    g_assembler->clear();
    assert(e1->parse("1?2:3"));
    e1->lookup_symbols();
    assert(!e1->eval_instr(instr));

    // eval_local_jr_distance
    int distance = 0;
    g_assembler->clear();
    assert(e1->parse("42"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("xpto"));
    assert(!g_obj_module->symtab()->get_symbol("xpto"));
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(g_obj_module->symtab()->get_symbol("xpto"));
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    e2 = new Expr();
    assert(e2->parse("40+2"));
    g_obj_module->add_equ("xpto", e2->clone());
    delete e2;
    assert(g_obj_module->symtab()->get_symbol("xpto"));
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("xpto");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("xpto");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("xpto"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1+x2"));
    e1->lookup_symbols();
    g_obj_module->add_equ("x3", e1->clone());
    assert(e1->parse("x3"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("+$"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("1?$:0"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    assert(e1->parse("0**123456789"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1**0"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2**4"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("+4"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("+$"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    assert(e1->parse("-4"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("!$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("~123"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0*$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$*0"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("1*$"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$*1"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$*2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/1"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("4/2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$/$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$/$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$%$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$%$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("10%3"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0+$"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->cur_section()->add_instr();
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("$+0"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("x1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == -4);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x2"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->set_cur_section("code");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->set_cur_section("data");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x2");
    g_obj_module->set_cur_section("");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->set_cur_section("code");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_obj_module->set_cur_section("");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x1+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("10+3"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("x2-x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x2-x1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("(0-x1)+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("(0-x1)+x2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS1);
    assert(e1->parse("0-x1+(x2-0)"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->add_opcode_void(0x05060708);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("0-x1+(x2-0)"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("10-3"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1<<4"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("16>>4"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0<1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1<1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2<1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0<=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1<=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2<=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0>1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1>1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2>1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0>=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1>=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2>=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0==1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1==1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2==1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0!=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1!=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2!=1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0<>1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1<>1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2<>1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("-1&16"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("2|8"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("10^15"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0&&0"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0&&1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1&&0"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1&&1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0||0"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0||1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1||0"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1||1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0^^0"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0^^1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1^^0"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1^^1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("0?1:2"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    assert(e1->parse("1?2:3"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    g_assembler->clear();
    g_obj_module->set_cur_section("code");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x1");
    g_obj_module->set_cur_section("data");
    g_obj_module->add_opcode_void(0x01020304);
    g_obj_module->add_label("x2");
    g_assembler->set_pass(Assembler::Pass::PASS2);
    assert(e1->parse("x2"));
    e1->lookup_symbols();
    assert(e1->eval_local_jr_distance(distance));
    assert(distance == 0);
    assert(e1->parse("x1"));
    e1->lookup_symbols();
    assert(!e1->eval_local_jr_distance(distance));

    delete e1;
    cout << "Expr tests passed." << endl;
}
#endif
