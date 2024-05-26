//-----------------------------------------------------------------------------
// z80asm - writing of object files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "object.h"
#include "symtab.h"
#include "utils.h"
#include <iostream>
#include <string>
using namespace std;

// write object files
class OFileWriter {
public:
    OFileWriter(const string& o_filename);
    bool write();		// write g_asm
    streampos write(ofstream& os);

private:
    string o_filename_;
    StringTable string_table_;

    streampos write_exprs(ofstream& os);
    void write_exprs(Symtab& symtab, ofstream& os);
    void write_patch_expr(Instr* instr, Patch* patch, ofstream& os);
    void write_expr(const string& target_name, Instr* instr, Patch* patch, ofstream& os);

    streampos write_symbols(ofstream& os);
    void write_symbols(Symtab& symtab, ofstream& os);

    streampos write_externs(ofstream& os);
    void write_externs(Symtab& symtab, ofstream& os);

    streampos write_modname(ofstream& os);
    streampos write_sections(ofstream& os);
    void write_sections(Section* section, ofstream& os);
};
