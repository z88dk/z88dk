//-----------------------------------------------------------------------------
// z80asm
// Symbol table
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "expr.h"
#include "symbol.h"
#include <cassert>
using namespace std;

Symtab g_global_defines;

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

