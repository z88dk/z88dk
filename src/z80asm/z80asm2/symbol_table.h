//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <unordered_map>

struct Symbol {
    std::string name;
    int value = 0;
    bool is_defined = false;
    bool is_constant = false;
    bool is_extern = false;
    Location location;
};

class SymbolTable {
public:
    SymbolTable() = default;
    void clear();

    bool add_symbol(const std::string& name, const Symbol& symbol);
    const Symbol& get_symbol(const std::string& name) const;

private:
    std::unordered_map<std::string, Symbol> symbols_;
};

extern SymbolTable g_symbol_table;
