//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <memory>
#include <string>
#include "icode.h"
#include "scan.h"
#include "symtab.h"
#include "parse.h"
#include "preproc.h"
using namespace std;

class ScannedLine;
class Object;
class Module;
class Section;
class Expr;
class Symbol;

class Asm {
public:
	bool assemble(const string& filename);
    bool is_active() const { return m_is_active; }

	shared_ptr<Object> object() { return m_object; }

	shared_ptr<Module> cur_module() { return m_object->cur_module(); }
	void set_cur_module(const string& name);

	shared_ptr<Section> cur_section() { return m_object->cur_module()->cur_section(); }
	void set_cur_section(const string& name);

    shared_ptr<Instr> asmpc_instr() { return m_asmpc_instr; }
    void add_asmpc_instr();

    friend ostream& operator<<(ostream& os, const Asm& asm_);

private:
    bool                m_is_active{ false };
	Parser				m_parser;
	shared_ptr<Object>	m_object;
    shared_ptr<Instr>   m_asmpc_instr;              // asmpc of current instruction
    int					m_start_errors{ 0 };		// errors at start of assembly

	// controler
	void assemble1(const string& filename);

	// errors
	bool got_errors();
};

extern Asm g_asm;
