//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "obj_symbol_type.h"
#include <string>

//-----------------------------------------------------------------------------
// Symbol type
//-----------------------------------------------------------------------------

ObjSymbolType parse_old_symbol_type(char type_char) {
    switch (type_char) {
#define X(id, name, ch, comment) \
    case ch: \
        return ObjSymbolType::name;
#include "../obj_symbol_type.def"
#undef X
    default:
        fatal_error("invalid symbol type: " +
                    std::to_string(static_cast<int>(type_char)));
    }
}

std::string to_short_string(ObjSymbolType type) {
    switch (type) {
#define X(id, name, ch, comment) \
    case ObjSymbolType::name: \
        return std::string(1, ch);
#include "../obj_symbol_type.def"
#undef X
    default:
        fatal_error("invalid symbol type: " +
                    std::to_string(static_cast<int>(type)));
    }
}

std::string to_string(ObjSymbolType type) {
    switch (type) {
#define X(id, name, ch, comment) \
    case ObjSymbolType::name: \
        return #name;
#include "../obj_symbol_type.def"
#undef X
    default:
        fatal_error("invalid symbol type: " +
                    std::to_string(static_cast<int>(type)));
    }
}

