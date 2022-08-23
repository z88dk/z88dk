//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "icode.h"
#include "lex.h"
#include "parse.h"
#include <string>
using namespace std;

class Object;
class Module;
class Group;
class Section;
class Expr;
class Symbol;

class Asm {
public:
	bool assemble(const string& filename);

	shared_ptr<Object> object() { return m_object; }
	shared_ptr<Module> cur_module() { return m_object->cur_module(); }
	shared_ptr<Group> cur_group() { return m_object->cur_module()->cur_group(); }
	shared_ptr<Section> cur_section() { return m_object->cur_module()->cur_section(); }

private:
	Parser				m_parser;
	shared_ptr<Object>	m_object;
	int					m_start_errors;		// errors at start of assembly

	// controler
	void assemble1(const string& filename);
	void set_cur_module(const string& name);
	void set_cur_group(const string& name);
	void set_cur_section(const string& name);

	// errors
	bool got_errors();

	bool add_label(const string& name);
};

extern Asm g_asm;
