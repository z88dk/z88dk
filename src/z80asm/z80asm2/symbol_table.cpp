//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "symbol_table.h"

SymbolTable g_symbol_table;

void SymbolTable::clear() {
    symbols_.clear();
}

bool SymbolTable::add_symbol(const std::string& name, const Symbol& symbol) {
    if (symbols_.find(name) != symbols_.end()) {
        g_errors.error(ErrorCode::SymbolRedefined, name);
        return false; // symbol already exists
    }
    else {
        symbols_[name] = symbol;
        return true;
    }
}

const Symbol& SymbolTable::get_symbol(const std::string& name) const {
    if (symbols_.find(name) == symbols_.end()) {
        static Symbol undefined_symbol;
        return undefined_symbol;
    }
    else {
        return symbols_.at(name);
    }
}

