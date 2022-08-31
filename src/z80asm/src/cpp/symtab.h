//-----------------------------------------------------------------------------
// z80asm
// symbol tables
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "expr.h"
#include <string>
#include <memory>
#include <map>
using namespace std;

class Section;
class Expr;
class Instr;

class Symbol {
public:
	enum class Type {
		Undef,						// not defined or extern
		Constant,					// constant value
		Asmpc,						// address computed at link time
		AsmpcPhased,				// constant linked to Instr
		Computed,					// DEFC computed at link time
	};

	enum class Scope {
		Local,						// local to module
		Public,						// defined and exported
		Extern,						// not defined and imported
		Global,						// Public if defined, Extern if not defined
	};

	// tags for constructors
	struct MakeUndef {};
	struct MakeConstant {};
	struct MakeAsmpc {};
	struct MakeAsmpcPhased {};
	struct MakeComputed {};

	Symbol(const string& name, Symbol::Scope scope = Scope::Local);
	Symbol(MakeUndef tag, const string& name, Symbol::Scope scope = Scope::Local);
	Symbol(MakeConstant tag, const string& name, int value, Symbol::Scope scope = Scope::Local);
	Symbol(MakeAsmpc tag, const string& name, shared_ptr<Instr> instr, Symbol::Scope scope = Scope::Local);
	Symbol(MakeAsmpcPhased tag, const string& name, shared_ptr<Instr> instr, Symbol::Scope scope = Scope::Local);
	Symbol(MakeComputed tag, const string& name, shared_ptr<Expr> expr, Symbol::Scope scope = Scope::Local);

	void update(const Symbol& other);
	void update(MakeConstant tag, int value);
	void update(MakeAsmpc tag, shared_ptr<Instr> instr);
	void update(MakeAsmpcPhased tag, shared_ptr<Instr> instr);
	void update(MakeComputed tag, shared_ptr<Expr> expr);

	const string& name() const { return m_name; }
	Type type() const { return m_type; }

	Scope scope() const { return m_scope; }
	void set_scope(Scope s) { m_scope = s; }

	bool is_touched() const { return m_is_touched; }
	void set_touched(bool f = true) { m_is_touched = f; }

	bool is_global_def() const { return m_is_global_def; }
	void set_global_def(bool f = true) { m_is_global_def = f; }

	shared_ptr<Section> section() { return m_section.lock(); }
	void set_section(weak_ptr<Section> s) { m_section = s; }

	const Location& location() const { return m_location; }
	void set_location(const Location& l) { m_location = l; }

	ExprResult value() const;

private:
	string	m_name;					// name
	int		m_value{ 0 };			// value if Constant
	weak_ptr<Instr>  m_instr;		// value if Asmpc or AsmpcPhased
	shared_ptr<Expr> m_expr;		// value if Computed

	Type	m_type{ Type::Undef };
	Scope	m_scope{ Scope::Local };

	bool	m_is_touched{ false };	// true if used and shall be writen to the object file
	bool	m_is_global_def{ false }; // head, tail, ...

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

	shared_ptr<Symbol> find_local(const string& name);
	shared_ptr<Symbol> find_global(const string& name);
	void copy_defines_to_cur_module();

	shared_ptr<Symbol> get_used(const string& name);
	shared_ptr<Symbol> add_define(const string& name, int value);		// -D
	shared_ptr<Symbol> add_global_def(const string& name, int value);	// head, tail
	shared_ptr<Symbol> add_local_def(const string& name, int value);	// DEFINE
	shared_ptr<Symbol> add(shared_ptr<Symbol> new_symbol);
	void declare(const string& name, Symbol::Scope scope);

private:
	Symtab	m_defines;
	Symtab	m_globals;

	shared_ptr<Symbol> create_or_update(Symtab& symtab, shared_ptr<Symbol> new_symbol);
	shared_ptr<Symbol> add_local_symbol(shared_ptr<Symbol> new_symbol);
	shared_ptr<Symbol> add_global_symbol(shared_ptr<Symbol> new_symbol);

	void declare_global(const string& name);
	void declare_public(const string& name);
	void declare_extern(const string& name);
};

extern Symbols g_symbols;
