//-----------------------------------------------------------------------------
// z80asm
// symbol tables
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "preproc.h"
#include "symtab.h"
#include "utils.h"
using namespace std;

Symtab g_symtab;

Symbol::Symbol(const string& name, int value)
	: m_name(name)
	, m_value(value)
	, m_filename(g_preproc.filename())
	, m_line_num(g_preproc.line_num()) {
}

Symtab::Symtab(Symtab* parent)
	: m_parent(parent) {
}

shared_ptr<Symbol> Symtab::add(const string& name) {
	Assert(find(name) == nullptr);

	auto symbol = make_shared<Symbol>(name);
	m_table[name] = symbol;
	return symbol;
}

shared_ptr<Symbol> Symtab::find(const string& name) {
	auto it = m_table.find(name);
	if (it == m_table.end())
		return nullptr;
	else
		return it->second;
}

shared_ptr<Symbol> Symtab::find_all(const string& name) {
	Symtab* table = this;
	while (table != nullptr) {
		auto symbol = table->find(name);
		if (symbol != nullptr)
			return symbol;
		table = table->m_parent;
	}
	return nullptr;
}
