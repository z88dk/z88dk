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

//-----------------------------------------------------------------------------

Symbol::Symbol(const string& name, int value,
	Symbol::Type type, Symbol::Scope scope,
	shared_ptr<Module> module, shared_ptr<Section> section)
	: m_name(name), m_value(value)
	, m_type(type), m_scope(scope)
	, m_module(module),m_section(section)
	, m_location(g_preproc.location()) {
}

//-----------------------------------------------------------------------------

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
	else {
		auto symbol = it->second;
		symbol->set_touched();
		return symbol;
	}
}

//-----------------------------------------------------------------------------

shared_ptr<Symbol> Symbols::find_local(const string& name) {
	return g_asm.cur_module()->symtab().find(name);
}

shared_ptr<Symbol> Symbols::find_global(const string& name) {
	return m_globals.find(name);
}

void Symbols::copy_defines_to_cur_module() {
	for (auto& symbol : m_defines)
		add_local_def(symbol.second->name(), symbol.second->value());
}

// create/update a symbol in the given table, error if already defined
shared_ptr<Symbol> Symbols::create_or_update(Symtab& symtab,
	const string& name, int value,
	Symbol::Type type, Symbol::Scope scope,
	shared_ptr<Module> module, shared_ptr<Section> section) {

	shared_ptr<Symbol> symbol = symtab.find(name);
	if (!symbol) {						// does not exist
		symbol = make_shared<Symbol>(name, value, type, scope, module, section);
		symbol->set_defined();
		Assert(symtab.insert(symbol));
		return symbol;
	}
	else if (!symbol->is_defined()) {	// declared but not defined
		symbol->set_value(value);
		if (symbol->type() < type)
			symbol->set_type(type);
		symbol->set_scope(scope);
		symbol->set_defined();
		symbol->set_module(module);
		symbol->set_section(section);
		symbol->set_location(g_preproc.location());
		return symbol;
	}
	else {								// already defined
		if (name.substr(0, 11) == "__CDBINFO__") {
			return symbol;				// ignore duplicates of these
		}
		else if (symbol->module().get() != nullptr &&
			symbol->module().get() != module.get()) {
			g_errors.error(ErrCode::DuplicateDefinition,
				symbol->module()->name() + "::" + name);
			return nullptr;
		}
		else {
			g_errors.error(ErrCode::DuplicateDefinition, name);
			return nullptr;
		}
	}
}

// refer to a symbol in an expression
// search for symbol in either local tree or global table,
// create undefined symbol if not found, return symbol
shared_ptr<Symbol> Symbols::get_used(const string& name) {
	// search in local table
	auto symbol = find_local(name);
	if (symbol)
		return symbol;

	// search in global table
	symbol = find_global(name);
	if (symbol)
		return symbol;

	// create undefined symbol
	symbol = make_shared<Symbol>(name, 0,
		Symbol::Type::Unknown, Symbol::Scope::Local,
		g_asm.cur_module(), g_asm.cur_section());
	Assert(g_asm.cur_module()->symtab().insert(symbol));
	return symbol;
}

// define a static symbol(from - D command line)
shared_ptr<Symbol> Symbols::add_define(const string& name, int value) {
	auto symbol = create_or_update(m_defines, name, value,
		Symbol::Type::Constant, Symbol::Scope::Local,
		nullptr, nullptr);
	return symbol;
}

// define a global define (head, tail, ...)
shared_ptr<Symbol> Symbols::add_global_def(const string& name, int value) {
	auto symbol = create_or_update(m_globals, name, value,
		Symbol::Type::Constant, Symbol::Scope::Public,
		nullptr, nullptr);
	if (symbol)
		symbol->set_global_def();
	return symbol;
}

// define a local define (DEFINE)
shared_ptr<Symbol> Symbols::add_local_def(const string& name, int value) {
	return add_local_symbol(name, value, Symbol::Type::Constant);
}

// local symbol
shared_ptr<Symbol> Symbols::add_local_symbol(const string& name, int value, Symbol::Type type) {
	auto symbol = create_or_update(g_asm.cur_module()->symtab(),
		name, value,
		type, Symbol::Scope::Local,
		g_asm.cur_module(), g_asm.cur_section());
	return symbol;
}

// global symbol
shared_ptr<Symbol> Symbols::add_global_symbol(const string& name, int value, Symbol::Type type) {
	auto symbol = create_or_update(m_globals,
		name, value,
		type, Symbol::Scope::Public,
		g_asm.cur_module(), g_asm.cur_section());
	return symbol;
}

// create a symbol in the local or global tree:
// a) if not already global/extern, create in the local symbol table
// b) if declared global/extern and not defined, define now
// c) if declared global/extern and defined -> error REDEFINED
// d) if in global table and not global/extern -> define a new local symbol
shared_ptr<Symbol> Symbols::add(const string& name, int value, Symbol::Type type) {
	auto symbol = find_global(name);
	if (!symbol) {						// not declared as global/extern
		// create/update local
		return create_or_update(g_asm.cur_module()->symtab(),
			name, value,
			type, Symbol::Scope::Local,
			g_asm.cur_module(), g_asm.cur_section());
	}
	else {
		// create/update global
		return create_or_update(m_globals,
			name, value,
			type, Symbol::Scope::Public,
			g_asm.cur_module(), g_asm.cur_section());
	}
}

void Symbols::declare(const string& name, Symbol::Scope scope) {
	switch (scope) {
	case Symbol::Scope::Global: declare_global(name); return;
	case Symbol::Scope::Public: declare_public(name); return;
	case Symbol::Scope::Extern: declare_extern(name); return;
	case Symbol::Scope::Local: Assert(0); return;
	default: Assert(0); return;
	}
}

void Symbols::declare_global(const string& name) {
	auto symbol = find_local(name);
	if (!symbol) {						// not local
		symbol = find_global(name);
		if (!symbol) {					// not local, not global -> declare as global
			symbol = make_shared<Symbol>(name, 0,
				Symbol::Type::Unknown, Symbol::Scope::Global,
				g_asm.cur_module(), g_asm.cur_section());
			Assert(m_globals.insert(symbol));
		}
		else if (symbol->module().get() == g_asm.cur_module().get() &&
			(symbol->scope() == Symbol::Scope::Public ||
				symbol->scope() == Symbol::Scope::Extern)) {
			// already declared public or extern in same module, ignore global
		}
		else if (symbol->module().get() != g_asm.cur_module().get() ||
			symbol->scope() != Symbol::Scope::Global) {
			g_errors.error(ErrCode::SymbolRedeclaration, name);
		}
		else {
			symbol->set_scope(Symbol::Scope::Global);
		}
	}
	else {								// local
		auto global_symbol = find_global(name);
		if (!global_symbol) {			// local, not global -> redeclare as global
			symbol->set_scope(Symbol::Scope::Global);
			g_asm.cur_module()->symtab().erase(name);
			Assert(m_globals.insert(symbol));
		}
		else {							// local, global not possible
			Assert(0);
		}
	}
}

void Symbols::declare_public(const string& name) {
	auto symbol = find_local(name);
	if (!symbol) {						// not local
		symbol = find_global(name);
		if (!symbol) {					// not local, not global -> declare as global
			symbol = make_shared<Symbol>(name, 0,
				Symbol::Type::Unknown, Symbol::Scope::Public,
				g_asm.cur_module(), g_asm.cur_section());
			Assert(m_globals.insert(symbol));
		}
		else if (symbol->module().get() == g_asm.cur_module().get() &&
			symbol->scope() == Symbol::Scope::Extern) {
			// Declared already EXTERN in the same module, change to PUBLIC
			symbol->set_scope(Symbol::Scope::Public);
		}
		else if (symbol->module().get() == g_asm.cur_module().get() &&
			symbol->scope() == Symbol::Scope::Global) {
			// Declared already GLOBAL in the same module, ignore
		}
		else if (symbol->module().get() != g_asm.cur_module().get() ||
			symbol->scope() != Symbol::Scope::Public) {
			g_errors.error(ErrCode::SymbolRedeclaration, name);
		}
		else {
			symbol->set_scope(Symbol::Scope::Public);
		}
	}
	else {								// local
		auto global_symbol = find_global(name);
		if (!global_symbol) {			// local, not global -> redeclare as global
			symbol->set_scope(Symbol::Scope::Public);
			g_asm.cur_module()->symtab().erase(name);
			Assert(m_globals.insert(symbol));
		}
		else {							// local, global not possible
			Assert(0);
		}
	}
}

void Symbols::declare_extern(const string& name) {
	auto symbol = find_local(name);
	if (!symbol) {						// not local
		symbol = find_global(name);
		if (!symbol) {					// not local, not global -> declare as global
			symbol = make_shared<Symbol>(name, 0,
				Symbol::Type::Unknown, Symbol::Scope::Extern,
				g_asm.cur_module(), g_asm.cur_section());
			Assert(m_globals.insert(symbol));
		}
		else if (symbol->module().get() == g_asm.cur_module().get() &&
			(symbol->scope() == Symbol::Scope::Public ||
				symbol->scope() == Symbol::Scope::Global)) {
			// Declared already PUBLIC or GLOBAL in the same module, ignore EXTERN
		}
		else if (symbol->module().get() != g_asm.cur_module().get() ||
			symbol->scope() != Symbol::Scope::Extern) {
			g_errors.error(ErrCode::SymbolRedeclaration, name);
		}
		else {
			symbol->set_scope(Symbol::Scope::Extern);
		}
	}
	else {								// local
		auto global_symbol = find_global(name);
		if (!global_symbol) {
			// If no external symbol of identical name has been declared, then re-declare local
			// symbol as external symbol, but only if local symbol is not defined yet
			if (!symbol->is_defined()) {
				symbol->set_scope(Symbol::Scope::Extern);
				g_asm.cur_module()->symtab().erase(name);
				Assert(m_globals.insert(symbol));
			}
			else {						// already declared local
				g_errors.error(ErrCode::SymbolRedeclaration, name);
			}
		}
		else {							// re-declaration not allowed
			g_errors.error(ErrCode::SymbolRedeclaration, name);
		}
	}
}

//-----------------------------------------------------------------------------
// C interface
//-----------------------------------------------------------------------------

void symtab_insert_static(const char* name, int value) {
	auto symbol = g_symbols.add_define(name, value);
	if (symbol) {
		if (g_args.verbose())
			cout << "Predefined constant: "
			<< name << " = " << int_to_hex(value, 4) << endl;
		define_static_def_sym(name, value);
	}
}

void symtab_insert_global_def(const char* name, int value) {
	auto symbol = g_symbols.add_global_def(name, value);
	if (symbol) {
		define_global_def_sym(name, value);
	}
}
