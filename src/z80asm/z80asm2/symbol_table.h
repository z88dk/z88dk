//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

class SymbolTable {
public:
    SymbolTable();
    void add_symbol(const std::string& name, int value);
    int lookup(const std::string& name) const;
};

extern SymbolTable g_symbol_table;
