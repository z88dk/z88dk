//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "obj_range_type.h"
#include <string>

//-----------------------------------------------------------------------------
// Range type
//-----------------------------------------------------------------------------

ObjRangeType parse_old_range_type(char range_char) {
    switch (range_char) {
#define X(id, name, ch, str, size, comment) \
    case ch:                                \
        return ObjRangeType::name;
#include "../obj_range_type.def"
#undef X
    default:
        fatal_error("invalid range type character '" +
                    std::string(1, range_char) + "'");
    }
}

std::string to_short_string(ObjRangeType range_type) {
    switch (range_type) {
#define X(id, name, ch, str, size, comment) \
    case ObjRangeType::name:                 \
        return str;
#include "../obj_range_type.def"
#undef X
    default:
        fatal_error("invalid range type: " +
                    std::to_string(static_cast<int>(range_type)));
    }
}

std::string to_string(ObjRangeType range_type) {
    switch (range_type) {
#define X(id, name, ch, str, size, comment) \
    case ObjRangeType::name:                 \
        return #name;
#include "../obj_range_type.def"
#undef X
    default:
        fatal_error("invalid range type: " +
                    std::to_string(static_cast<int>(range_type)));
    }
}
