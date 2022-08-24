//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm.h"
#include "errors.h"
#include "icode.h"
#include "if.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
#include <set>
using namespace std;

Asm g_asm;

bool Asm::assemble(const string& filename) {
	m_parser.clear();

	// create object and default module, section and group
	m_object = make_shared<Object>(filename);
	set_cur_module(m_object->name());
	set_cur_group("");
	set_cur_section("");

	// clear globals
	g_symbols.globals().clear();

	// copy defines as locals in module
	g_symbols.copy_defines_to_cur_module();

	m_start_errors = g_errors.count();

	assemble1(filename);

	m_object.reset();
	m_start_errors = 0;

	return !got_errors();
}

void Asm::assemble1(const string& filename) {
	if (!g_preproc.open(filename, true))
		return;

	m_parser.parse();
	if (got_errors())
		return;

	m_object->check_relative_jumps();
	if (got_errors())
		return;

}

void Asm::set_cur_module(const string& name) {
	m_object->insert_module(name);
}

void Asm::set_cur_group(const string& name) {
	cur_module()->insert_group(name);
}

void Asm::set_cur_section(const string& name) {
	cur_module()->insert_section(name);
}

bool Asm::got_errors() {
	return m_start_errors != g_errors.count();
}
