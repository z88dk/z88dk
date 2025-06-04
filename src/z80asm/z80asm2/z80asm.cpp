//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "input_files.h"
#include "location.h"
#include "operator.h"
#include "preproc.h"
#include "scanner.h"
#include "token.h"
#include "utils.h"
#include <algorithm>
#include <cassert>
#include <cassert>
#include <cctype>
#include <cstring>
#include <deque>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <list>
#include <queue>
#include <sstream>
#include <stack>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

//-----------------------------------------------------------------------------
// Expression and symbol table
//-----------------------------------------------------------------------------

class Symtab;

class Expr {
public:
    enum class Status {
        OK,
        SCAN_FAILED,
        EOL_EXPECTED,
        OPERAND_EXPECTED,
        MISMATCHED_PARENS,
        MISMATCHED_TERNARY,
        INSUFICIENT_OPERANDS,
        TOO_MANY_OPERANDS,
        UNDEFINED_SYMBOL,
    };

    Status get_status() const { return m_status; }

    bool parse(const string& line);
    bool parse(Scanner& in);
    bool eval(int asmpc, Symtab* symtab, int& result);

    string to_string() const;
    string rpn_to_string() const;

    Expr* clone();

private:
    vector<Token> m_infix;
    vector<Token> m_postfix;
    Status m_status{ Status::OK };

    bool is_unary(Scanner& in) const;
    bool to_RPN(Scanner& in);
    bool check_syntax();
};

enum class SymType {
    GLOBAL_DEFINE,
    CONSTANT,
    ADDRESS,
    EXPRESSION,
};

class Symbol {
public:
    Symbol(const string& name);
    Symbol(const Symbol& other) = delete;
    virtual ~Symbol();
    Symbol& operator=(const Symbol& other) = delete;

    const string& get_name() const { return m_name; }
    SymType get_sym_type() const { return m_sym_type; }
    int get_value() const { return m_value; }
    Expr* get_expr() { return m_expr; }
    bool is_in_eval() const { return m_in_eval; }

    void set_sym_type(SymType sym_type) { m_sym_type = sym_type; }
    void set_value(int value) { m_value = value; }
    void set_expr(Expr* expr);
    void set_in_eval() { m_in_eval = true; }
    void clear_in_eval() { m_in_eval = false; }

private:
    const string m_name;        // symbol name
    SymType m_sym_type{ SymType::CONSTANT };
    int m_value{ 0 };           // constant or address offset
    Expr* m_expr{ nullptr };    // expression
    bool m_in_eval{ false };    // detect recursive evaluation
};

class Symtab {
public:
    Symtab() {}
    Symtab(const Symtab& other) = delete;
    virtual ~Symtab();
    Symtab& operator=(const Symtab& other) = delete;

    void clear();
    Symbol* get_symbol(const string& name); // nullptr if not found
    bool add_symbol(const string& name, Symbol* symbol);
    bool eval(int asmpc, const string& name, int& result);

private:
    unordered_map<string, Symbol*> m_table;
};

extern Symtab g_global_defines;

//@@.cpp

//-----------------------------------------------------------------------------
// Expression and symbol table
//-----------------------------------------------------------------------------

Symtab g_global_defines;

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

        if (ttype == TType::INT || ttype == TType::IDENT|| ttype == TType::ASMPC) {
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
                assert(0);
            }
            break;

        default:
            assert(0);
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

Symbol::Symbol(const string& name)
    : m_name(name) {
}

Symbol::~Symbol() {
    delete m_expr;
}

void Symbol::set_expr(Expr* expr) {
    if (m_expr)
        delete m_expr;
    m_expr = expr;
}

Symtab::~Symtab() {
    clear();
}

void Symtab::clear() {
    for (auto& it : m_table) {
        delete it.second;
    }
    m_table.clear();
}

Symbol* Symtab::get_symbol(const string& name) {
    auto it = m_table.find(name);
    if (it == m_table.end())
        return nullptr;
    else
        return it->second;
}

bool Symtab::add_symbol(const string& name, Symbol* symbol) {
    if (get_symbol(name)) {
        return false;
    }
    else {
        m_table[name] = symbol;
        return true;
    }
}

bool Symtab::eval(int asmpc, const string& name, int& result) {
    result = 0;
    Symbol* symbol = get_symbol(name);
    if (!symbol) {
        g_error.error_undefined_symbol(name);
        return false;
    }
    else if (symbol->is_in_eval()) {
        g_error.error_recursive_evaluation(name);
        return false;
    }
    else {
        bool ok = true;
        symbol->set_in_eval();
        switch (symbol->get_sym_type()) {
        case SymType::GLOBAL_DEFINE:
        case SymType::CONSTANT:
        case SymType::ADDRESS:
            result = symbol->get_value();
            break;

        case SymType::EXPRESSION:
            ok = symbol->get_expr()->eval(asmpc, this, result);
            break;

        default:
            assert(0);
        }
        symbol->clear_in_eval();
        return ok;
    }

}

//@@.h

//-----------------------------------------------------------------------------
// Patch
//-----------------------------------------------------------------------------

enum class PatchType {
    JR,
    N,
    NN,
};

class Patch {
public:
    Patch(Expr* expr, int offset, PatchType patch_type);
    Patch(const Patch& other) = delete;
    virtual ~Patch();
    Patch& operator=(const Patch& other) = delete;

    Expr* get_expr() { return m_expr; }
    int get_offset() const { return m_offset; }
    PatchType get_patch_type() const { return m_patch_type; }
    int size() const;

private:
    Expr* m_expr;
    int m_offset;
    PatchType m_patch_type;
};

//@@.cpp

//-----------------------------------------------------------------------------
// Patch
//-----------------------------------------------------------------------------

Patch::Patch(Expr* expr, int offset, PatchType patch_type)
    : m_expr(expr), m_offset(offset), m_patch_type(patch_type) {}

Patch::~Patch() {
    delete m_expr;
}

int Patch::size() const {
    switch (m_patch_type) {
    case PatchType::JR:
    case PatchType::N:
        return 1;
    case PatchType::NN:
        return 2;
    default:
        assert(0);
        return 0;
    }
}

//@@.h

//-----------------------------------------------------------------------------
// Object Module
//-----------------------------------------------------------------------------

class ObjModule {
public:
    ObjModule() {}
    ObjModule(const ObjModule& other) = delete;
    virtual ~ObjModule();
    ObjModule& operator=(const ObjModule& other) = delete;

    Symtab* get_symtab() { return &m_symtab; }
    int get_asmpc() const { return m_asmpc; }
    int get_offset() const { return static_cast<int>(m_code.size()); }

    void clear();
    void next_opcode();
    void add_constant(const string& name, Expr* expr);
    void add_label(const string& name);
    void set_assume(int value) { m_assume = value; }
    void add_opcode_void(long long opcode);
    void add_opcode_jr(long long opcode, Expr* expr);
    void add_opcode_n(long long opcode, Expr* expr);
    void add_opcode_nn(long long opcode, Expr* expr);

private:
    Symtab m_symtab;
    vector<unsigned char> m_code;
    vector<Patch*> m_patches;
    int m_asmpc{ 0 };
    int m_assume{ 0 };
};

extern ObjModule g_obj_module;

//@@.cpp

//-----------------------------------------------------------------------------
// Object Module
//-----------------------------------------------------------------------------

ObjModule g_obj_module;

ObjModule::~ObjModule() {
    clear();
}

void ObjModule::clear() {
    m_symtab.clear();
    m_code.clear();
    for (auto& patch : m_patches)
        delete patch;
    m_patches.clear();
    m_asmpc = get_offset();
    m_assume = 0;
}

void ObjModule::next_opcode() {
    m_asmpc = get_offset();
}

void ObjModule::add_constant(const string& name, Expr* expr) {
    if (m_symtab.get_symbol(name)) {
        g_error.error_duplicate_definition(name);
        delete expr;
    }
    else {
        auto symbol = new Symbol(name);
        symbol->set_sym_type(SymType::CONSTANT);
        symbol->set_expr(expr);
        m_symtab.add_symbol(name, symbol);
    }
}

void ObjModule::add_label(const string& name) {
    if (m_symtab.get_symbol(name)) {
        g_error.error_duplicate_definition(name);
    }
    else {
        auto expr = new Expr;
        bool ok = expr->parse(std::to_string(m_asmpc));
        assert(ok);
        auto symbol = new Symbol(name);
        symbol->set_sym_type(SymType::ADDRESS);
        symbol->set_expr(expr);
        m_symtab.add_symbol(name, symbol);
    }
}

void ObjModule::add_opcode_void(long long opcode) {
    bool out = false;
    if (out || (opcode & 0xFF00000000000000LL) != 0) {
        out = true;
        m_code.push_back((opcode >> 56) & 0xFF);
    }
    if (out || (opcode & 0x00FF000000000000LL) != 0) {
        out = true;
        m_code.push_back((opcode >> 48) & 0xFF);
    }
    if (out || (opcode & 0x0000FF0000000000LL) != 0) {
        out = true;
        m_code.push_back((opcode >> 40) & 0xFF);
    }
    if (out || (opcode & 0x000000FF00000000LL) != 0) {
        out = true;
        m_code.push_back((opcode >> 32) & 0xFF);
    }
    if (out || (opcode & 0x00000000FF000000LL) != 0) {
        out = true;
        m_code.push_back((opcode >> 24) & 0xFF);
    }
    if (out || (opcode & 0x0000000000FF0000LL) != 0) {
        out = true;
        m_code.push_back((opcode >> 16) & 0xFF);
    }
    if (out || (opcode & 0x000000000000FF00LL) != 0) {
        out = true;
        m_code.push_back((opcode >> 8) & 0xFF);
    }
    m_code.push_back(opcode & 0xFF);
}

void ObjModule::add_opcode_jr(long long opcode, Expr* expr) {
    add_opcode_void(opcode);
    auto patch = new Patch(expr, get_offset(), PatchType::JR);
    for (int i = 0; i < patch->size(); ++i)
        add_opcode_void(0);
    m_patches.push_back(patch);
}

void ObjModule::add_opcode_n(long long opcode, Expr* expr) {
    add_opcode_void(opcode);
    auto patch = new Patch(expr, get_offset(), PatchType::N);
    for (int i = 0; i < patch->size(); ++i)
        add_opcode_void(0);
    m_patches.push_back(patch);
}

void ObjModule::add_opcode_nn(long long opcode, Expr* expr) {
    add_opcode_void(opcode);
    auto patch = new Patch(expr, get_offset(), PatchType::NN);
    for (int i = 0; i < patch->size(); ++i)
        add_opcode_void(0);
    m_patches.push_back(patch);
}

//@@.h

//-----------------------------------------------------------------------------
// Line parser
//-----------------------------------------------------------------------------

class LineParser {
public:
    bool parse(const string& line);

private:
    struct Elem {
        Token token;
        Expr* expr{ nullptr };
        int expr_value{ 0 };

        Elem() {}
        Elem(const Elem& other)
            : token(other.token), expr(other.expr ? other.expr->clone() : nullptr), expr_value(other.expr_value) {}
        Elem& operator=(const Elem& other) {
            if (&other != this) {
                token = other.token;
                expr = other.expr->clone();
                expr_value = other.expr_value;
            }
            return *this;
        }
        virtual ~Elem() {
            delete expr;
        }
    };

    struct Elems {
        vector<Elem> elems;

        Elems() {};
        Elems(const Elems& other) {
            elems.insert(elems.end(), other.elems.begin(), other.elems.end());
        }
        Elems& operator = (const Elems& other) {
            if (&other != this)
                elems.insert(elems.end(), other.elems.begin(), other.elems.end());
            return *this;
        }
        virtual ~Elems() {
            elems.clear();
        }
    };

    Scanner m_in;   // input tokens
    Elems m_elems;  // synthatic elements

    struct ParseQueueElem {
        int state{ 0 };
        int in_pos{ 0 };
        Elems elems;
    };

    //@@BEGIN:actions_decl
    void action_ident_colon();
    void action_ident_equ_expr();
    void action_assume_const_expr();
    void action_nop();
    void action_jr_expr();
    void action_jr_nz_comma_expr();
    void action_jr_z_comma_expr();
    void action_jr_nc_comma_expr();
    void action_jr_c_comma_expr();
    void action_ld_a_comma_expr();
    void action_ld_a_comma_lparen_expr_rparen();
    void action_ld_a_comma_a();
    void action_ld_a_comma_b();
    //@@END

    // state in the parsing state machine
	struct State {
		unordered_map<Keyword, int> keyword_next;
		unordered_map<TType, int>	ttype_next;
		void(LineParser::*action)();
	};

	static inline State m_states[] = {
		//@@BEGIN: states
		{ /* 0:  */
		  { {Keyword::ASSUME, 1}, {Keyword::JR, 10}, {Keyword::LD, 29}, {Keyword::NOP, 42}, },
		  { {TType::IDENT, 4}, },
		  nullptr,
		},
		{ /* 1: ASSUME */
		  { },
		  { {TType::CONST_EXPR, 2}, },
		  nullptr,
		},
		{ /* 2: ASSUME CONST_EXPR */
		  { },
		  { {TType::END, 3}, },
		  nullptr,
		},
		{ /* 3: ASSUME CONST_EXPR END */
		  { },
		  { },
		  &LineParser::action_assume_const_expr,
		},
		{ /* 4: IDENT */
		  { {Keyword::EQU, 7}, },
		  { {TType::COLON, 5}, },
		  nullptr,
		},
		{ /* 5: IDENT COLON */
		  { },
		  { {TType::END, 6}, },
		  nullptr,
		},
		{ /* 6: IDENT COLON END */
		  { },
		  { },
		  &LineParser::action_ident_colon,
		},
		{ /* 7: IDENT EQU */
		  { },
		  { {TType::EXPR, 8}, },
		  nullptr,
		},
		{ /* 8: IDENT EQU EXPR */
		  { },
		  { {TType::END, 9}, },
		  nullptr,
		},
		{ /* 9: IDENT EQU EXPR END */
		  { },
		  { },
		  &LineParser::action_ident_equ_expr,
		},
		{ /* 10: JR */
		  { {Keyword::C, 11}, {Keyword::NC, 17}, {Keyword::NZ, 21}, {Keyword::Z, 25}, },
		  { {TType::EXPR, 15}, },
		  nullptr,
		},
		{ /* 11: JR C */
		  { },
		  { {TType::COMMA, 12}, },
		  nullptr,
		},
		{ /* 12: JR C COMMA */
		  { },
		  { {TType::EXPR, 13}, },
		  nullptr,
		},
		{ /* 13: JR C COMMA EXPR */
		  { },
		  { {TType::END, 14}, },
		  nullptr,
		},
		{ /* 14: JR C COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_jr_c_comma_expr,
		},
		{ /* 15: JR EXPR */
		  { },
		  { {TType::END, 16}, },
		  nullptr,
		},
		{ /* 16: JR EXPR END */
		  { },
		  { },
		  &LineParser::action_jr_expr,
		},
		{ /* 17: JR NC */
		  { },
		  { {TType::COMMA, 18}, },
		  nullptr,
		},
		{ /* 18: JR NC COMMA */
		  { },
		  { {TType::EXPR, 19}, },
		  nullptr,
		},
		{ /* 19: JR NC COMMA EXPR */
		  { },
		  { {TType::END, 20}, },
		  nullptr,
		},
		{ /* 20: JR NC COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_jr_nc_comma_expr,
		},
		{ /* 21: JR NZ */
		  { },
		  { {TType::COMMA, 22}, },
		  nullptr,
		},
		{ /* 22: JR NZ COMMA */
		  { },
		  { {TType::EXPR, 23}, },
		  nullptr,
		},
		{ /* 23: JR NZ COMMA EXPR */
		  { },
		  { {TType::END, 24}, },
		  nullptr,
		},
		{ /* 24: JR NZ COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_jr_nz_comma_expr,
		},
		{ /* 25: JR Z */
		  { },
		  { {TType::COMMA, 26}, },
		  nullptr,
		},
		{ /* 26: JR Z COMMA */
		  { },
		  { {TType::EXPR, 27}, },
		  nullptr,
		},
		{ /* 27: JR Z COMMA EXPR */
		  { },
		  { {TType::END, 28}, },
		  nullptr,
		},
		{ /* 28: JR Z COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_jr_z_comma_expr,
		},
		{ /* 29: LD */
		  { {Keyword::A, 30}, },
		  { },
		  nullptr,
		},
		{ /* 30: LD A */
		  { },
		  { {TType::COMMA, 31}, },
		  nullptr,
		},
		{ /* 31: LD A COMMA */
		  { {Keyword::A, 32}, {Keyword::B, 34}, },
		  { {TType::EXPR, 36}, {TType::LPAREN, 38}, },
		  nullptr,
		},
		{ /* 32: LD A COMMA A */
		  { },
		  { {TType::END, 33}, },
		  nullptr,
		},
		{ /* 33: LD A COMMA A END */
		  { },
		  { },
		  &LineParser::action_ld_a_comma_a,
		},
		{ /* 34: LD A COMMA B */
		  { },
		  { {TType::END, 35}, },
		  nullptr,
		},
		{ /* 35: LD A COMMA B END */
		  { },
		  { },
		  &LineParser::action_ld_a_comma_b,
		},
		{ /* 36: LD A COMMA EXPR */
		  { },
		  { {TType::END, 37}, },
		  nullptr,
		},
		{ /* 37: LD A COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_ld_a_comma_expr,
		},
		{ /* 38: LD A COMMA LPAREN */
		  { },
		  { {TType::EXPR, 39}, },
		  nullptr,
		},
		{ /* 39: LD A COMMA LPAREN EXPR */
		  { },
		  { {TType::RPAREN, 40}, },
		  nullptr,
		},
		{ /* 40: LD A COMMA LPAREN EXPR RPAREN */
		  { },
		  { {TType::END, 41}, },
		  nullptr,
		},
		{ /* 41: LD A COMMA LPAREN EXPR RPAREN END */
		  { },
		  { },
		  &LineParser::action_ld_a_comma_lparen_expr_rparen,
		},
		{ /* 42: NOP */
		  { },
		  { {TType::END, 43}, },
		  nullptr,
		},
		{ /* 43: NOP END */
		  { },
		  { },
		  &LineParser::action_nop,
		},
		//@@END
	};
};

//@@.cpp

//-----------------------------------------------------------------------------
// Line parser
//-----------------------------------------------------------------------------

bool LineParser::parse(const string& line) {
    if (!m_in.scan(line))
        return false;       // scanning failed

    if (m_in.peek().is(TType::END))
        return true;        // empty line

    vector<ParseQueueElem> parse_queue;

    // add initial state
    ParseQueueElem queue_elem;
    queue_elem.state = 0;
    queue_elem.in_pos = m_in.get_pos();
    parse_queue.push_back(queue_elem);

    // check all possible paths
    bool parse_ok = false;
    while (!parse_queue.empty()) {
        ParseQueueElem queue_elem = parse_queue.back();
        parse_queue.pop_back();
        auto& current_state = m_states[queue_elem.state];

        // check if at final state
        if (current_state.action) {
            g_obj_module.next_opcode();
            m_elems = queue_elem.elems; // setup data for function call
            (this->*current_state.action)();
            parse_ok = true;
            break;
        }

        // check CONST_EXPR
        m_in.set_pos(queue_elem.in_pos);
        auto it = current_state.ttype_next.find(TType::CONST_EXPR);
        if (it != current_state.ttype_next.end()) {
            Elem elem;
            elem.expr = new Expr;
            bool ok = elem.expr->parse(m_in);
            if (!ok) {
                delete elem.expr;
                elem.expr = nullptr;
            }
            else {
                bool ok = elem.expr->eval(g_obj_module.get_asmpc(), g_obj_module.get_symtab(), elem.expr_value);
                if (!ok) {
                    delete elem.expr;
                    elem.expr = nullptr;
                }
                else {
                    auto new_state = queue_elem;
                    new_state.state = it->second;
                    new_state.in_pos = m_in.get_pos();
                    new_state.elems.elems.push_back(elem);
                    parse_queue.push_back(new_state);
                }
            }
        }

        // check EXPR
        m_in.set_pos(queue_elem.in_pos);
        it = current_state.ttype_next.find(TType::EXPR);
        if (it != current_state.ttype_next.end()) {
            Elem elem;
            elem.token = Token{ TType::EXPR, false };
            elem.expr = new Expr;
            bool ok = elem.expr->parse(m_in);
            if (!ok) {
                delete elem.expr;
                elem.expr = nullptr;
            }
            else {
                auto new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.get_pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }

        // check token
        m_in.set_pos(queue_elem.in_pos);
        TType ttype = m_in.peek().get_ttype();
        it = current_state.ttype_next.find(ttype);
        if (it != current_state.ttype_next.end()) {
            Elem elem;
            elem.token = m_in.peek();
            m_in.next();

            auto new_state = queue_elem;
            new_state.state = it->second;
            new_state.in_pos = m_in.get_pos();
            new_state.elems.elems.push_back(elem);
            parse_queue.push_back(new_state);
        }

        // check keyword
        m_in.set_pos(queue_elem.in_pos);
        Keyword keyword = m_in.peek().get_keyword();
        if (keyword != Keyword::NONE) {
            auto it = current_state.keyword_next.find(keyword);
            if (it != current_state.keyword_next.end()) {
                Elem elem;
                elem.token = m_in.peek();
                m_in.next();

                auto new_state = queue_elem;
                new_state.state = it->second;
                new_state.in_pos = m_in.get_pos();
                new_state.elems.elems.push_back(elem);
                parse_queue.push_back(new_state);
            }
        }
    }

    if (!parse_ok)
        g_error.error_syntax();

    return parse_ok;
}

//@@BEGIN:actions_impl
void LineParser::action_ident_colon() {
	g_obj_module.add_label(m_elems.elems[1-1].token.get_svalue());


}

void LineParser::action_ident_equ_expr() {
	g_obj_module.add_constant(m_elems.elems[1-1].token.get_svalue(), m_elems.elems[3-1].expr->clone());


}

void LineParser::action_assume_const_expr() {
	g_obj_module.set_assume(m_elems.elems[2-1].expr_value);


}

void LineParser::action_nop() {
	g_obj_module.add_opcode_void(0x00);


}

void LineParser::action_jr_expr() {
	g_obj_module.add_opcode_jr(0x18, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_nz_comma_expr() {
	g_obj_module.add_opcode_jr(0x20, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_z_comma_expr() {
	g_obj_module.add_opcode_jr(0x28, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_nc_comma_expr() {
	g_obj_module.add_opcode_jr(0x30, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_jr_c_comma_expr() {
	g_obj_module.add_opcode_jr(0x38, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_a_comma_expr() {
	g_obj_module.add_opcode_n(0x3E, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_a_comma_lparen_expr_rparen() {
	g_obj_module.add_opcode_nn(0x3A, m_elems.elems[4-1].expr->clone());


}

void LineParser::action_ld_a_comma_a() {
	g_obj_module.add_opcode_void(0x7F);


}

void LineParser::action_ld_a_comma_b() {
	g_obj_module.add_opcode_void(0x78);

}

//@@END

//@@test

//-----------------------------------------------------------------------------
// Test
//-----------------------------------------------------------------------------

void parse_file(const string& filename) {
    g_preproc.clear();
    g_obj_module.clear();

    g_input_files.push_file(filename);
	string line;
	while (g_input_files.getline(line)) {
		g_preproc.expand(line);
		string expanded_line;
		while (g_preproc.getline(expanded_line)) {
			g_location.set_expanded_text(expanded_line);
			cout << g_location.get_filename() << ":" << g_location.get_line_num() << ": " << line << endl << expanded_line << endl;
            LineParser parser;
            if (!parser.parse(expanded_line))
                cout << "parse failed" << endl;
		}
	}
}

int main(int argc, char* argv[]) {
	for (int i = 1; i < argc; i++) {
		parse_file(argv[i]);
	}
}

