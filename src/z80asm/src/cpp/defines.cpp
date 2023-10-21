//-----------------------------------------------------------------------------
// z80asm
// macro symbols
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "defines.h"
#include "if.h"
#include <algorithm>
using namespace std;

Macro::Macro(const string& name, const ScannedLine& body)
    : m_name(name), m_body(body) {
}

void Macro::push_arg(const string& arg) {
	if (find(m_args.begin(), m_args.end(), arg) != m_args.end())
		g_errors.error(ErrCode::DuplicateDefinition, arg);
	else
		m_args.push_back(arg);
}

//-----------------------------------------------------------------------------

Macros::Macros(Macros* parent)
	: m_parent(parent) {}

void Macros::add(shared_ptr<Macro> macro) {
	const string& name = macro->name();
	if (m_table.find(name) != m_table.end())
		g_errors.error(ErrCode::DuplicateDefinition, name);
	else
		m_table[name] = macro;
}

void Macros::remove(const string& name) {
	m_table.erase(name);
}

void Macros::clear() {
	m_table.clear();
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

