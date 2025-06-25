//-----------------------------------------------------------------------------
// z80asm
// Assembler
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
using namespace std;

class Assembler {
public:
    enum class Pass { NOT_ASSEMBLING = 0, PASS1 = 1, PASS2 = 2 };

    void clear();
    void assemble_file(const string& filename);

    const string& asm_filename() const { return m_asm_filename; }
    const string& obj_filename() const { return m_obj_filename; }

    Pass pass() const { return m_pass; }
    void set_pass(Pass pass) { m_pass = pass; }

private:
	string m_basename;
    string m_asm_filename;
    string m_obj_filename;
    Pass m_pass{ Pass::NOT_ASSEMBLING };

    void init(const string& filename);
    bool assemble();
    bool parse();
    void convert_global_to_extern_public();
    bool has_undefined_symbols();
    void resolve_local_exprs();
};

extern Assembler* g_assembler;
