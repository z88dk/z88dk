//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "utils.h"
#include <string>

// all strings stored in strpool for memory efficiency and fast comparisons

struct SourceLoc {
    const char* file = "";
    int line = 0;
    int column = 0;

    SourceLoc();
    SourceLoc(const std::string& file, int line, int column);

    bool empty() const;
    std::string to_string() const;
};
