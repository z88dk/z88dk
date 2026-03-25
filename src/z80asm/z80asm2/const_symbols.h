//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "source_loc.h"
#include "string_interner.h"
#include <string_view>
#include <unordered_map>

struct ConstSymbol {
    StringInterner::Id name_id = 0; // interned string
    int value = 0;
    SourceLoc loc;                  // where it was defined
};

struct ConstSymbols {
    std::unordered_map<StringInterner::Id, ConstSymbol> symbols;

    void clear();

    void set(StringInterner::Id name_id, int value, const SourceLoc& loc);
    const ConstSymbol* get(StringInterner::Id name_id) const;
    void erase(StringInterner::Id name_id);

    void set(const std::string_view name, int value, const SourceLoc& loc);
    const ConstSymbol* get(const std::string_view name) const;
    void erase(const std::string_view name);
};

