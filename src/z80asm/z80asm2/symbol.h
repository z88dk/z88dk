//-----------------------------------------------------------------------------
// z80asm
// Symbol table
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <unordered_map>
using namespace std;

class Expr;
class Instr;
class Result;
class Symtab;

enum class SymType {
    NOT_DEFINED,
    GLOBAL_DEF,
    CONST,
    INSTR,
    EXPR,
};

class Symbol {
public:
    Symbol(const string& name, Symtab* parent);
    Symbol(const Symbol& other) = delete;
    virtual ~Symbol();
    Symbol& operator=(const Symbol& other) = delete;
    void clear();

    const string& name() const { return m_name; }
    SymType sym_type() const { return m_sym_type; }
    int value() const { return m_value; }
    Instr* instr() { return m_instr; }
    Expr* expr() { return m_expr; }
    bool in_eval() const { return m_in_eval; }

    void set_global_def(int value);
    void set_global_def(Expr* expr);
    void set_const(int value);
    void set_const(Expr* expr);
    void set_instr(Instr* instr);
    void set_expr(Expr* expr);
    void set_in_eval(bool f=true) { m_in_eval = f; }

private:
    const string m_name;        // symbol name
    Symtab* m_parent{ nullptr };
    SymType m_sym_type{ SymType::CONST };
    int m_value{ 0 };           // constant
    Instr* m_instr{ nullptr };  // address
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
    Symbol* add_symbol(const string& name);
    void remove_symbol(const string& name);

    auto begin() { return m_table.begin(); }
    auto end() { return m_table.end(); }
    auto cbegin() const { return m_table.cbegin(); }
    auto cend() const { return m_table.cend(); }
    auto size() const { return m_table.size(); }
    bool empty() const { return m_table.empty(); }

private:
    unordered_map<string, Symbol*> m_table;
};

extern Symtab* g_global_defines;
