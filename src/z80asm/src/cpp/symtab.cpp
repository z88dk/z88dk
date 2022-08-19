//-----------------------------------------------------------------------------
// z80asm
// symbol tables
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "errors.h"
#include "if.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
#include <iostream>
using namespace std;

Symtab g_def_symbols;		
Symtab g_symbols;

Symbol::Symbol(const string& name)
	: m_name(name)
	, m_location(g_preproc.location()) {
}

Symbol::Symbol(const string& name, int value)
	: m_name(name)
	, m_value(value)
	, m_type(Type::Constant)
	, m_is_computed(true)
	, m_location(g_preproc.location()) {
}

Symbol::Symbol(const string& name, shared_ptr<Expr> expr)
	: m_name(name)
	, m_expr(expr)
	, m_type(Type::Computed)
	, m_is_computed(true)
	, m_location(g_preproc.location()) {
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

//-----------------------------------------------------------------------------
// C interface
//-----------------------------------------------------------------------------

void symtab_insert_global_def(const char* name, int value) {
	auto symbol = make_shared<Symbol>(name, value);
	if (g_def_symbols.insert(symbol)) {
		if (g_args.verbose())
			cout << "Predefined constant: "
			<< name << " = " << int_to_hex(value, 4) << endl;
		define_static_def_sym(name, value);
	}
	else {
		g_errors.error(ErrCode::DuplicateDefinition, name);
	}	
}

