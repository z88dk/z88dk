//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "icode.h"
#include "preproc.h"
#include <memory>
using namespace std;

Icode::Icode(shared_ptr<Section> parent)
	: m_parent(parent)
	, m_filename(g_preproc.filename())
	, m_line_num(g_preproc.line_num()) {
}

void Icode::set_asmpc(size_t n) {
	m_asmpc = n;
	if (m_prev_asmpc == UndefinedAsmpc)
		m_prev_asmpc = n;
}

Section::Section(const string& name, shared_ptr<Group> parent)
	: m_name(name), m_parent(parent) {
}

void Section::push_back(shared_ptr<Icode> node) {
	node->set_asmpc(asmpc());
	m_nodes.push_back(node);
}

size_t Section::asmpc() const {
	if (m_nodes.empty())
		return 0;
	else
		return m_nodes.back()->asmpc() + m_nodes.back()->size();
}
