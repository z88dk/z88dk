//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "source_loc.h"
#include "strings.h"
#include <cstdint>
#include <string>

SourceLoc::SourceLoc(int file, int ln, int col)
    : line(static_cast<uint32_t>(ln)),
      file_id(static_cast<uint16_t>(file)),
      column(static_cast<uint16_t>(col)) {
}

SourceLoc SourceLoc::make(const std::string& file, int line, int column) {
    return SourceLoc(g_strings.intern(file), line, column);
}

bool SourceLoc::empty() const {
    return file_id == 0 && line == 0 && column == 0;
}

std::string SourceLoc::to_string() const {
    if (empty()) {
        return "";
    }

    return g_strings.to_string(file_id) + ":" +
           std::to_string(line) + ":" + std::to_string(column);
}
