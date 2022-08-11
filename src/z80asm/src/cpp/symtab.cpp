//-----------------------------------------------------------------------------
// z80asm
// symbol tables
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "errors.h"
#include "if.h"
#include "symbol.h"
#include "symtab.h"
#include "utils.h"
#include <iostream>
using namespace std;

static shared_ptr<Symtab> g_global_def_symbols;
static shared_ptr<Symtab> g_global_symbols;

Symtab::Symtab(shared_ptr<Symtab> parent)
	: m_parent(parent) {
}

bool Symtab::insert(shared_ptr<Symbol> symbol) {
	const string& name = symbol->name();
	if (find(name) != nullptr) {
		if (name.substr(0, 11) == "__CDBINFO__")
			return true;	// ignore duplicates of these
		else
			return false;
	}
	else {
		m_table[name] = symbol;
		return true;
	}
}

shared_ptr<Symbol> Symtab::find(const string& name) {
	auto it = m_table.find(name);
	if (it == m_table.end())
		return nullptr;
	else
		return it->second;
}

shared_ptr<Symbol> Symtab::find_all(const string& name) {
	auto symbol = find(name);
	if (symbol)
		return symbol;
	else if (m_parent.lock()) 
		return m_parent.lock()->find(name);
	else
		return nullptr;
}

static void init_globals() {
	if (!g_global_def_symbols) {
		g_global_def_symbols = make_shared<Symtab>();
		g_global_symbols = make_shared<Symtab>(g_global_def_symbols);
	}
}

shared_ptr<Symtab> global_def_symbols() {
	init_globals();
	return g_global_def_symbols;
}

shared_ptr<Symtab> global_symbols() {
	init_globals();
	return g_global_symbols;
}

void symtab_insert_global_def(const char* name, int value) {
	auto symbol = make_shared<Symbol>(name, value);
	if (global_def_symbols()->insert(symbol)) {
		if (g_args.verbose())
			cout << "Predefined constant: "
			<< name << " = " << int_to_hex(value, 4) << endl;
		define_static_def_sym(name, value);
	}
	else {
		g_errors.error(ErrCode::DuplicateDefinition, name);
	}	
}

