//-----------------------------------------------------------------------------
// z80asm
// object file format
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

#define OBJ_VERSION     "18"
#define O_FILE_HEADER	"Z80RMF" OBJ_VERSION

class OFileWriter {
public:
    OFileWriter(const string& filename);
	bool write();		// write g_asm, g_symtab
    bool got_errors() const { return g_errors.count() > m_start_errors; }

    streampos write(ofstream& os);

private:
	string m_filename;
    StringTable m_string_table;

	streampos write_exprs(ofstream& os);
	void write_exprs(Symtab& symtab, ofstream& os);
	void write_patch_expr(shared_ptr<Instr> instr, shared_ptr<Patch> patch, ofstream& os);
	void write_expr(const string& target_name, shared_ptr<Instr> instr, shared_ptr<Patch> patch, ofstream& os);

	streampos write_symbols(ofstream& os);
    void write_symbols(Symtab& symtab, ofstream& os);

	streampos write_externs(ofstream& os);
    void write_externs(Symtab& symtab, ofstream& os);

	streampos write_modname(ofstream& os);
	streampos write_sections(ofstream& os);
	void write_sections(shared_ptr<Section> section, ofstream& os);
    int m_start_errors{ 0 };
};
