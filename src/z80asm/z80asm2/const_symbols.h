//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "source_loc.h"
#include "strings.h"
#include <unordered_map>

struct ConstSymbol {
    StringId name_id;       // interned string
    int value = 0;
    SourceLoc loc;          // where it was defined
};

struct ConstSymbols {
    std::unordered_map<StringId, ConstSymbol> symbols;

    void set(StringId name_id, int value, const SourceLoc& loc);
    const ConstSymbol* get(StringId name_id) const;
    void erase(StringId name_id);

#ifdef _DEBUG
    void dump_symbols() const;
#endif
};
