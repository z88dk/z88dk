//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

//-----------------------------------------------------------------------------
// Range type
//-----------------------------------------------------------------------------

enum class ObjRangeType {
#define X(id, name, ch, str, size, comment) \
    name = id,
#include "../obj_range_type.def"
#undef X
};

ObjRangeType parse_old_range_type(char range_char);
std::string to_short_string(ObjRangeType range_type);
std::string to_string(ObjRangeType range_type);
