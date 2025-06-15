//-----------------------------------------------------------------------------
// z80asm
// Symbol table
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "expr.h"
#include "obj_module.h"
#include "options.h"
#include "symbol.h"
#include <cassert>
#include <iostream>
using namespace std;

Symtab* g_global_defines{ nullptr };

Symbol::Symbol(const string& name, Symtab* parent)
    : m_name(name), m_parent(parent) {
}

Symbol::~Symbol() {
    clear();
}

void Symbol::clear() {
    m_sym_scope = SymScope::NONE;
    m_sym_type = SymType::UNDEFINED;
    m_is_global_def = false;
    m_value = 0;
    m_instr = nullptr;
    delete m_expr;
    m_expr = nullptr;
    m_in_eval = false;
}

void Symbol::set_global_def(int value) {
    clear();
    m_sym_scope = SymScope::LOCAL;
    m_sym_type = SymType::CONSTANT;
    m_is_global_def = true;
    m_value = value;
}

void Symbol::set_global_def(Expr* expr) {
    int value = 0;
    if (expr->eval_const(m_parent, value)) {
        set_global_def(value);
    }
    else {
        g_error->error_constant_expression_expected();
    }
    delete expr;
}

void Symbol::set_value(int value) {
    clear();
    m_sym_type = SymType::CONSTANT;
    m_value = value;
}

void Symbol::set_value(Expr* expr) {
    int value = 0;
    if (expr->eval_const(m_parent, value)) {
        set_value(value);
    }
    else {
        g_error->error_constant_expression_expected();
    }
    delete expr;
}

void Symbol::set_instr(Instr* instr) {
    clear();
    m_sym_type = SymType::ADDRESS;
    m_instr = instr;
}

void Symbol::set_expr(Expr* expr) {
    clear();
    int value = 0;
    if (expr->eval_const(m_parent, value)) {
        set_value(value);
        delete expr;
    }
    else {
        m_sym_type = SymType::COMPUTED;
        m_expr = expr;
    }
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

Symbol* Symtab::add_symbol(const string& name) {
    if (get_symbol(name)) {
        g_error->error_duplicate_definition(name);
        return nullptr;
    }
    else {
        Symbol* symbol = new Symbol(name, this);
        m_table[name] = symbol;
        return symbol;
    }
}

void Symtab::remove_symbol(const string& name) {
    auto it = m_table.find(name);
    if (it != m_table.end()) {
        delete it->second;
        m_table.erase(it);
    }
}

void Symtab::add_global_def(const string& name, int value) {
    auto symbol = get_symbol(name);
    if (!symbol)
        symbol = add_symbol(name);

    if (symbol->sym_type() != SymType::UNDEFINED)
        g_error->error_duplicate_definition(name);
    else {
        symbol->set_global_def(value);

        // only show global defines
        if (g_options->verbose() && this == g_global_defines)
            cout << "define " << name << " = " << value << endl;
    }
}
