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

Symbol::Symbol(const string& name)
    : m_name(name) {
    update_definition();
}

Symbol::~Symbol() {
    clear();
}

void Symbol::clear() {
    m_location.clear();
    m_sym_scope = SymScope::LOCAL;
    m_sym_type = SymType::UNDEFINED;
    m_is_global_def = false;
    m_value = 0;
    m_instr = nullptr;
    delete m_expr;
    m_expr = nullptr;
    m_in_eval = false;
    m_touched = false;
}

void Symbol::set_global_def(int value) {
    m_sym_type = SymType::CONSTANT;
    m_value = value;
    m_is_global_def = true;
}

void Symbol::set_global_def(Expr* expr) {
    int value = 0;
    if (expr->eval_const(value)) {
        set_global_def(value);
    }
    else {
        g_error->error_constant_expression_expected();
    }
    delete expr;
}

void Symbol::set_constant(int value) {
    m_sym_type = SymType::CONSTANT;
    m_value = value;
}

void Symbol::set_constant(Expr* expr) {
    int value = 0;
    if (expr->eval_const(value)) {
        set_constant(value);
    }
    else {
        g_error->error_constant_expression_expected();
    }
    delete expr;
}

void Symbol::set_instr(Instr* instr) {
    m_sym_type = SymType::ADDRESS;
    m_instr = instr;
}

void Symbol::set_expr(Expr* expr) {
    int value = 0;
    Instr* instr = nullptr;

    if (expr->eval_const(value)) {
        set_constant(value);
        delete expr;
    }
    else if (expr->eval_instr(instr)) {
        set_instr(instr);
    }
    else {
        m_sym_type = SymType::COMPUTED;
        m_expr = expr;
    }
}

void Symbol::update_definition() {
    m_location = *g_location;
    m_section = g_obj_module->cur_section();
}

Symtab::~Symtab() {
    clear();
}

void Symtab::clear() {
    for (auto& it : m_table) {
        delete it.second;
    }
    m_table.clear();

    for (auto& symbol : m_deleted) {
        delete symbol;
    }
    m_deleted.clear();
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
        Symbol* symbol = new Symbol(name);
        m_table[name] = symbol;
        return symbol;
    }
}

void Symtab::remove_symbol(const string& name) {
    auto it = m_table.find(name);
    if (it != m_table.end()) {
        m_deleted.push_back(it->second);    // some expression may still refer to symbol
        m_table.erase(it);
    }
}

Symbol* Symtab::add_global_def(const string& name, int value) {
    auto symbol = get_symbol(name);
    if (!symbol)
        symbol = add_symbol(name);

    if (symbol->sym_type() != SymType::UNDEFINED ||
        symbol->sym_scope() == SymScope::EXTERN)
        g_error->error_duplicate_definition(name);
    else {
        symbol->set_global_def(value);
        symbol->update_definition();

        // only show global defines
        if (g_options->verbose() && this == g_global_defines)
            cout << "define " << name << " = " << value << endl;
    }

    return symbol;
}

Symbol* Symtab::add_label(const string& name, Instr* instr) {
    auto symbol = get_symbol(name);
    if (!symbol)
        symbol = add_symbol(name);

    if (symbol->sym_type() != SymType::UNDEFINED ||
        symbol->sym_scope() == SymScope::EXTERN)
        g_error->error_duplicate_definition(name);
    else {
        symbol->set_instr(instr);
        symbol->update_definition();
    }

    return symbol;
}

Symbol* Symtab::add_equ(const string& name, Expr* expr) {
    auto symbol = get_symbol(name);
    if (!symbol)
        symbol = add_symbol(name);

    if (symbol->sym_type() != SymType::UNDEFINED ||
        symbol->sym_scope() == SymScope::EXTERN)
        g_error->error_duplicate_definition(name);
    else {
        symbol->set_expr(expr);
        symbol->update_definition();
    }

    return symbol;
}

Symbol* Symtab::touch_symbol(const string& name) {
    auto symbol = get_symbol(name);
    if (!symbol)
        symbol = add_symbol(name);
    symbol->set_touched();
    return symbol;
}

Symbol* Symtab::declare_extern(const string& name) {
    auto symbol = get_symbol(name);
    if (!symbol)
        symbol = add_symbol(name);

    if (symbol->sym_type() != SymType::UNDEFINED)
        g_error->error_duplicate_definition(name);
    else {
        symbol->set_sym_scope(SymScope::EXTERN);
    }

    return symbol;

}

bool Symtab::has_undefined_symbols() const {
    bool has_undefined = false;
    for (auto& it : m_table) {
        Symbol* symbol = it.second;
        if (symbol->sym_type() == SymType::UNDEFINED &&
            symbol->sym_scope() != SymScope::EXTERN) {
            *g_location = symbol->location();
            g_error->error_undefined_symbol(symbol->name());
            g_location->clear();
            has_undefined = true;
        }
    }
    return has_undefined;
}
