//-----------------------------------------------------------------------------
// z80asm
// symbol tables
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <memory>
#include <unordered_map>
using namespace std;

class Module;
class Section;

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

	Symbol(const string& name, int value = 0);

	const string& name() const { return m_name; }
	int value() const { return m_value; }
	void set_value(int n) { m_value = n; }
	Type type() const { return m_type; }
	void set_type(Type t) { m_type = t; }
	Scope scope() const { return m_scope; }
	void set_scope(Scope s) { m_scope = s; }
	bool is_computed() const { return m_is_computed; }
	void set_computed(bool f = true) { m_is_computed = f; }
	bool is_defined() const { return m_is_defined; }
	void set_defined(bool f = true) { m_is_defined = f; }
	bool is_used() const { return m_is_used; }
	void set_used(bool f = true) { m_is_used = f; }
	bool is_global_def() const { return m_is_global_def; }
	void set_global_def(bool f = true) { m_is_global_def = f; }
	shared_ptr<Module> module() { return m_module; }
	void set_module(shared_ptr<Module> m) { m_module = m; }
	shared_ptr<Section> section() { return m_section; }
	void set_section(shared_ptr<Section> s) { m_section = s; }
	const string& filename() const { return m_filename; }
	int line_num() const { return m_line_num; }

private:
	string	m_name;					// name
	int		m_value{ 0 };			// value if constant or computed

	Type	m_type{ Type::Unknown };
	Scope	m_scope{ Scope::Local };

	bool	m_is_computed{ false };	// true if Type::Computed or Type::Address and value computed
	bool	m_is_defined{ false };	// true if symbol was defined in the current module
	bool	m_is_used{ false };		// true if symbol was used and shall be writen to the object file
	bool	m_is_global_def{ false };// true for __head, __tail, __size symbols

	shared_ptr<Module>	m_module;	// module where defined
	shared_ptr<Section>	m_section;	// section where defined

	string	m_filename;				// file where defined
	int		m_line_num{ 0 };		// line where defined
};


class Symtab {
public:
	Symtab(Symtab* parent = nullptr);

	shared_ptr<Symbol> add(const string& name);
	shared_ptr<Symbol> find(const string& name);
	shared_ptr<Symbol> find_all(const string& name);

private:
	Symtab*	m_parent{nullptr};		// parent, if any
	unordered_map<string, shared_ptr<Symbol>>	m_table;	// symbols table
};

extern Symtab g_symtab;
