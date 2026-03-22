//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "source_loc.h"
#include <string>

int error_count();
void error(const SourceLoc& loc, const std::string& msg);
void warning(const SourceLoc& loc, const std::string& msg);
void note(const SourceLoc& loc, const std::string& msg);

inline void error(const std::string& msg) {
    error(SourceLoc{}, msg);
}

inline void warning(const std::string& msg) {
    warning(SourceLoc{}, msg);
}

inline void note(const std::string& msg) {
    note(SourceLoc{}, msg);
}
