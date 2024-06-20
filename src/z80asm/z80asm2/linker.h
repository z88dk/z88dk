//-----------------------------------------------------------------------------
// z80asm - linker
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "symtab.h"
#include <string>
#include <vector>
using namespace std;

class Linker {
public:
    Linker(const string& bin_filename);

    void link_library_modules();
    void allocate_addresses();
    void write();

private:
    string bin_filename_;
    Symtab global_symbols_;             // globals in the order defined

    void load_global_symbols();         // load global_symbols_
    void link_extern_symbols(vector<Symbol*>& unresolved);   // link all possible extern symbols, return unresolved
};
