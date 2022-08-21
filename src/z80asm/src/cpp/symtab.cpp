//-----------------------------------------------------------------------------
// z80asm
// symbol tables
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "asm.h"
#include "errors.h"
#include "icode.h"
#include "if.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
#include <iostream>
#include <set>
#include <vector>
using namespace std;

Symbols g_symbols;

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

// return all symbols with the given name in the same order as the modules
vector<shared_ptr<Symbol>> Symbols::find_in_modules(const string& name) {
	set<shared_ptr<Symbol>> symbol_set;
	vector<shared_ptr<Symbol>> symbol_list;

	for (auto& module : g_asm.object()->modules()) {
		auto symbol = module->symtab().find(name);
		if (symbol) {
			if (symbol_set.insert(symbol).second) {		// insert done, not duplicate
				symbol_list.push_back(symbol);
			}
		}
	}

	return symbol_list;
}

bool Symbols::declare(const string& name, Symbol::Scope scope) {
	switch (scope) {
	case Symbol::Scope::Global: return declare_global(name);
	case Symbol::Scope::Public: return declare_public(name);
	case Symbol::Scope::Extern: return declare_extern(name);
	case Symbol::Scope::Local: Assert(0); return false;
	default: Assert(0); return false;
	}
}

bool Symbols::declare_global(const string& /*name*/) {
	return false;	
}

bool Symbols::declare_public(const string& /*name*/) {
	return false;
}

bool Symbols::declare_extern(const string& /*name*/) {
	return false;
}

//-----------------------------------------------------------------------------
// C interface
//-----------------------------------------------------------------------------

void symtab_insert_global_def(const char* name, int value) {
	auto symbol = make_shared<Symbol>(name, value);
	if (g_symbols.defines().insert(symbol)) {
		if (g_args.verbose())
			cout << "Predefined constant: "
			<< name << " = " << int_to_hex(value, 4) << endl;
		define_static_def_sym(name, value);
	}
	else {
		g_errors.error(ErrCode::DuplicateDefinition, name);
	}	
}

