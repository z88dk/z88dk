//-----------------------------------------------------------------------------
// z80asm
// user symbol
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <memory>
using namespace std;

class Section;
class Expr;

class Symbol {
public:
	enum class Type {
		Undefined,					// not defined yet
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

	Symbol(const string& name);
	Symbol(const string& name, int value);
	Symbol(const string& name, shared_ptr<Expr> expr);

	const string& name() const { return m_name; }
	int value() const { return m_value; }
	void set_value(int n) { m_value = n; }
	shared_ptr<Expr> expr() { return m_expr; }
	Type type() const { return m_type; }
	void set_type(Type t) { m_type = t; }
	Scope scope() const { return m_scope; }
	void set_scope(Scope s) { m_scope = s; }
	bool is_computed() const { return m_is_computed; }
	void set_computed(bool f = true) { m_is_computed = f; }
	bool is_used() const { return m_is_used; }
	void set_used(bool f = true) { m_is_used = f; }
	shared_ptr<Section> section() { return m_section.lock(); }
	void set_section(weak_ptr<Section> s) { m_section = s; }
	const string& filename() const { return m_filename; }
	int line_num() const { return m_line_num; }

private:
	string	m_name;					// name
	int		m_value{ 0 };			// value if constant or computed
	shared_ptr<Expr> m_expr;		// DEFC symbol

	Type	m_type{ Type::Undefined };
	Scope	m_scope{ Scope::Local };

	bool	m_is_computed{ false };	// true if Type::Computed or Type::Address and value computed
	bool	m_is_used{ false };		// true if symbol was used and shall be writen to the object file

	weak_ptr<Section>	m_section;	// section where defined

	string	m_filename;				// file where defined
	int		m_line_num{ 0 };		// line where defined
};
