//-----------------------------------------------------------------------------
// z80asm
// object file format
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once
#include <iostream>
#include <fstream>
using namespace std;

class OFileWriter {
public:
	bool write();		// write g_asm, g_symtab

private:
	string m_last_filename;

	streampos write_exprs(ofstream& os);
	void write_defc_exprs(Symtab& symtab, ofstream& os);
	void write_patch_expr(shared_ptr<Patch> patch, ofstream& os);
	void write_expr(const string& target_name, shared_ptr<Patch> patch, ofstream& os);

	streampos write_symbols(ofstream& os);
	streampos write_externsym(ofstream& os);
	streampos write_modname(ofstream& os);
	streampos write_code(ofstream& os);
};
