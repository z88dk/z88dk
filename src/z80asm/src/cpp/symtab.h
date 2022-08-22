//-----------------------------------------------------------------------------
// z80asm
// symbol tables
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include <string>
#include <memory>
#include <map>
using namespace std;

class Module;
class Section;
class Expr;
class Icode;

class Symbol {
public:
	enum class Type {
		Unknown,					// not known yet
		Constant,					// constant value
		Address,					// address computed at link time
		Computed,					// DEFC computed at link time
	};

	enum class Scope {
		Local,						// local to module
		Public,						// defined and exported
		Extern,						// not defined and imported
		Global,						// Public if defined, Extern if not defined
	};

	Symbol(const string& name, int value = 0,
		Symbol::Type type = Type::Unknown, Symbol::Scope scope = Scope::Local,
		shared_ptr<Module> module = nullptr, shared_ptr<Section> section = nullptr);

	const string& name() const { return m_name; }

	int value() const { return m_value; }
	void set_value(int n) { m_value = n; }

	shared_ptr<Expr> expr() { return m_expr; }
	void set_expr(shared_ptr<Expr> e) { m_expr = e; }

	Type type() const { return m_type; }
	void set_type(Type t) { m_type = t; }

	Scope scope() const { return m_scope; }
	void set_scope(Scope s) { m_scope = s; }

	bool is_computed() const { return m_is_computed; }
	void set_computed(bool f = true) { m_is_computed = f; }

	bool is_defined() const { return m_is_defined; }
	void set_defined(bool f = true) { m_is_defined = f; }

	bool is_touched() const { return m_is_touched; }
	void set_touched(bool f = true) { m_is_touched = f; }

	bool is_global_def() const { return m_is_global_def; }
	void set_global_def(bool f = true) { m_is_global_def = f; }

	shared_ptr<Module> module() { return m_module.lock(); }
	void set_module(weak_ptr<Module> m) { m_module = m; }

	shared_ptr<Section> section() { return m_section.lock(); }
	void set_section(weak_ptr<Section> s) { m_section = s; }

	const Location& location() const { return m_location; }
	void set_location(const Location& l) { m_location = l; }

private:
	string	m_name;					// name
	int		m_value{ 0 };			// value if constant or evaluated if computed or address
	shared_ptr<Expr> m_expr;		// DEFC expression

	Type	m_type{ Type::Unknown };
	Scope	m_scope{ Scope::Local };

	bool	m_is_computed{ false };	// true if Type::Computed or Type::Address and value computed
	bool	m_is_defined{ false };	// true if defined
	bool	m_is_touched{ false };	// true if used and shall be writen to the object file
	bool	m_is_global_def{ false }; // true for __head, __tail, __size symbols

	weak_ptr<Module>	m_module;	// module where defined
	weak_ptr<Section>	m_section;	// section where defined

	Location m_location;			// location where defined
};

class Symtab {
public:
	bool insert(shared_ptr<Symbol> symbol);
	void erase(const string& name) { m_table.erase(name); }
	void clear() { m_table.clear(); }
	auto begin() { return m_table.begin(); }
	auto end() { return m_table.end(); }

	shared_ptr<Symbol> find(const string& name);

private:
	map<string, shared_ptr<Symbol>>	m_table;	// symbols table
};

class Symbols {
public:
	Symtab& defines() { return m_defines; }
	Symtab& globals() { return m_globals; }

	shared_ptr<Symbol> add_define(const string& name, int value);		// -D
	shared_ptr<Symbol> add_global_def(const string& name, int value);	// head, tail
	shared_ptr<Symbol> add_local_def(const string& name, int value);	// DEFINE

	shared_ptr<Symbol> get_used(const string& name);
	shared_ptr<Symbol> add(const string& name, int value, Symbol::Type type);
	shared_ptr<Symbol> update(const string& name, int value, Symbol::Type type);

	void declare(const string& name, Symbol::Scope scope);

private:
	Symtab	m_defines;
	Symtab	m_globals;

	shared_ptr<Symbol> find_local(const string& name);
	shared_ptr<Symbol> find_global(const string& name);

	shared_ptr<Symbol> create_or_update(Symtab& symtab,
		const string& name, int value,
		Symbol::Type type, Symbol::Scope scope,
		shared_ptr<Module> module, shared_ptr<Section> section);

	shared_ptr<Symbol> add_local_symbol(const string& name, int value, Symbol::Type type);
	shared_ptr<Symbol> add_global_symbol(const string& name, int value, Symbol::Type type);

	void declare_global(const string& name);
	void declare_public(const string& name);
	void declare_extern(const string& name);
};

extern Symbols g_symbols;
