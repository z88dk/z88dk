//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "obj_file.h"
#include <string_view>

bool write_object_file(const ObjectFile& obj, std::string_view filename) {
    (void)obj;
    (void)filename;
    return false;
}
