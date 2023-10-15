//-----------------------------------------------------------------------------
// z80asm
// assembler
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
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
    if (g_args.verbose())
        cout << "Assembling '" << filename << "'" << endl;

    m_parser.clear();

	// create object and default module, section and group
	m_object = make_shared<Object>(filename);
	set_cur_module(m_object->name());
	set_cur_section("");

	// clear globals
	g_symbols.globals().clear();

	// copy defines as locals in module
	g_symbols.copy_defines_to_cur_module();
    m_is_active = true;

	m_start_errors = g_errors.count();

    g_errors.push_location(Location(filename));
	assemble1(filename);
    g_errors.pop_location();

    m_is_active = false;
	m_object.reset();
	m_start_errors = 0;

    if (g_args.verbose())
        cout << endl;

    return !got_errors();
}

void Asm::assemble1(const string& filename) {
    // create parent directory of object file
    string o_filename = g_args.o_filename(filename);
    string parent_dir = fs::path(o_filename).parent_path().generic_string();
    if (!parent_dir.empty() && !std::filesystem::is_directory(parent_dir)) {
        // check if it failed, and it was not created by another process
        if (!fs::create_directories(parent_dir) &&
            !std::filesystem::is_directory(parent_dir)) {    
            g_errors.error(ErrCode::DirCreate, parent_dir);
            perror(parent_dir.c_str());
            return;
        }
    }

    if (!g_preproc.open(filename, true))
		return;

	m_parser.parse();
	if (got_errors())
		return;

#if 0
	m_object->check_relative_jumps();
	if (got_errors())
		return;
#endif

	m_object->patch_local_exprs();
	if (got_errors())
		return;

	g_symbols.check_undefined_symbols();
	if (got_errors())
		return;

	m_object->check_undefined_symbols();
	if (got_errors())
		return;

	m_object->write_obj_file();
	if (got_errors())
		return;

    // make legacy data structures
    assemble_file(o_filename.c_str());
}

void Asm::set_cur_module(const string& name) {
	m_object->add_module(name);
}

void Asm::set_cur_section(const string& name) {
	cur_module()->add_section(name);
}

void Asm::add_asmpc_instr() {
    m_asmpc_instr = g_asm.cur_section()->add_asmpc();
}

bool Asm::got_errors() {
	return m_start_errors != g_errors.count();
}

ostream& operator<<(ostream& os, const Asm& asm_) {
    os << *asm_.m_object;
    return os;
}
