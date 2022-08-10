//-----------------------------------------------------------------------------
// z80asm
// symbol tables
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <memory>
#include <map>
using namespace std;

class Symbol;

class Symtab {
public:
	Symtab(shared_ptr<Symtab> parent = nullptr);

	bool insert(shared_ptr<Symbol> symbol);
	void erase(const string& name) { m_table.erase(name); }
	void clear() { m_table.clear(); }
	shared_ptr<Symbol> find(const string& name);
	shared_ptr<Symbol> find_all(const string& name);

private:
	weak_ptr<Symtab> m_parent;		// parent, if any
	map<string, shared_ptr<Symbol>>	m_table;	// symbols table
};

shared_ptr<Symtab> global_def_symbols();// symbols defined by -D and predefined constants	
shared_ptr<Symtab> global_symbols();	// symbols declared PUBLIC, EXTERN or GLOBAL
