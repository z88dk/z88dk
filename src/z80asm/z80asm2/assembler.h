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
    bool assemble_file(const string& filename);

private:
    string m_filename;
    string m_obj_filename;

    void init(const string& filename);
    bool parse();
    bool has_undefined_symbols();
    bool resolve_local_exprs();
};
