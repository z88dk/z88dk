//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "source_loc.h"
#include "utils.h"

SourceLoc::SourceLoc()
    : file(strpool("")), line(0), column(0) {
}

SourceLoc::SourceLoc(const std::string& file, int line, int column)
    : file(strpool(file)), line(line), column(column) {
}

bool SourceLoc::empty() const {
    return file[0] == '\0' && line == 0 && column == 0;
}

std::string SourceLoc::to_string() const {
    if (empty()) {
        return "";
    }

    return std::string(file) + ":" +
           std::to_string(line) + ":" + std::to_string(column);
}
