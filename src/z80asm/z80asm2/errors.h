//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "source_loc.h"
#include <string>

size_t error_count();
void error(const SourceLoc& loc, std::string_view msg);
void warning(const SourceLoc& loc, std::string_view msg);
void note(const SourceLoc& loc, std::string_view msg);

inline void error(std::string_view msg) {
    error(SourceLoc{}, msg);
}

inline void warning(std::string_view msg) {
    warning(SourceLoc{}, msg);
}

inline void note(std::string_view msg) {
    note(SourceLoc{}, msg);
}
