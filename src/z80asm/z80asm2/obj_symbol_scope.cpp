//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "obj_symbol_scope.h"
#include <string>

//-----------------------------------------------------------------------------
// Symbol scope
//-----------------------------------------------------------------------------

ObjSymbolScope parse_old_symbol_scope(char scope_char) {
    switch (scope_char) {
#define X(id, name, ch, comment) \
    case ch: \
        return ObjSymbolScope::name;
#include "../obj_symbol_scope.def"
#undef X
    default:
        fatal_error("invalid symbol scope character: '" +
                    std::string(1, scope_char) + "'");
    }
}

std::string to_short_string(ObjSymbolScope scope) {
    switch (scope) {
#define X(id, name, ch, comment) \
    case ObjSymbolScope::name: \
        return std::string(1, ch);
#include "../obj_symbol_scope.def"
#undef X
    default:
        fatal_error("invalid symbol scope: " +
                    std::to_string(static_cast<int>(scope)));
    }
}

std::string to_string(ObjSymbolScope scope) {
    switch (scope) {
#define X(id, name, ch, comment) \
    case ObjSymbolScope::name: \
        return #name;
#include "../obj_symbol_scope.def"
#undef X
    default:
        fatal_error("invalid symbol scope: " +
                    std::to_string(static_cast<int>(scope)));
    }
}

