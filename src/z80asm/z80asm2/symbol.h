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
