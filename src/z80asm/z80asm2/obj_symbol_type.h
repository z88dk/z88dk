//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

//-----------------------------------------------------------------------------
// Symbol type
//-----------------------------------------------------------------------------

enum class ObjSymbolType {
#define X(id, name, ch, comment) \
    name = id,
#include "../obj_symbol_type.def"
#undef X
};

ObjSymbolType parse_old_symbol_type(char type_char);
std::string to_short_string(ObjSymbolType type);
std::string to_string(ObjSymbolType type);
