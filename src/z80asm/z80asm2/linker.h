//-----------------------------------------------------------------------------
// z80asm - linker
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "symtab.h"
#include <string>
using namespace std;

class Linker {
public:
    Linker(const string& bin_filename);

    void pull_library_modules();
    void link();
    void write_bin_files();

private:
    string bin_filename_;
    Symtab global_symbols_;

    void update_global_symbols();
};
