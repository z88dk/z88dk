//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

//-----------------------------------------------------------------------------
// Symbol scope
//-----------------------------------------------------------------------------

enum class ObjSymbolScope {
#define X(id, name, ch, comment) \
    name = id,
#include "../obj_symbol_scope.def"
#undef X
};

ObjSymbolScope parse_old_symbol_scope(char scope_char);
std::string to_short_string(ObjSymbolScope scope_type);
std::string to_string(ObjSymbolScope scope_type);
