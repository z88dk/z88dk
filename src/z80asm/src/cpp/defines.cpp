//-----------------------------------------------------------------------------
// z80asm
// macro symbols
// Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "defines.h"
#include "if.h"
#include <algorithm>
using namespace std;

Macro::Macro(const string& name, const string& body)
	: m_name(name), m_body(body) {}

void Macro::push_arg(const string& arg) {
	if (find(m_args.begin(), m_args.end(), arg) != m_args.end())
		error_symbol_redefined(arg.c_str());
	else
		m_args.push_back(arg);
}

void Macro::push_body(const string& text) {
	if (!m_body.empty())
		m_body.push_back(' ');
	m_body += text;
}

Macros::Macros(Macros* parent)
	: m_parent(parent) {}

void Macros::add(shared_ptr<Macro> macro) {
	const string& name = macro->name();
	if (m_table.find(name) != m_table.end())
		error_symbol_redefined(name.c_str());
	else
		m_table[name] = macro;
}

void Macros::remove(const string& name) {
	m_table.erase(name);
}

shared_ptr<Macro> Macros::find(const string& name) const {
	auto it = m_table.find(name);
	if (it == m_table.end())
		return nullptr;
	else
		return it->second;
}

shared_ptr<Macro> Macros::find_all(const string& name) const {
	const Macros* macros = this;
	while (macros) {
		auto macro = macros->find(name);
		if (macro)
			return macro;
		else
			macros = macros->m_parent;
	}
	return nullptr;
}

