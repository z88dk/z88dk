//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "source_loc.h"
#include "strings.h"
#include <cstdint>
#include <string>

SourceLoc::SourceLoc(uint filename_id, size_t ln, size_t col)
    : line(static_cast<uint32_t>(ln)),
      filename_id(static_cast<uint16_t>(filename_id)),
      column(static_cast<uint16_t>(col)) {
}

SourceLoc::SourceLoc(std::string_view filename, size_t ln, size_t col)
    : line(static_cast<uint32_t>(ln)),
      filename_id(static_cast<uint16_t>(g_strings.intern(filename))),
      column(static_cast<uint16_t>(col)) {
}

void SourceLoc::clear() {
    filename_id = 0;
    line = 0;
    column = 0;
}

bool SourceLoc::empty() const {
    return filename_id == 0 && line == 0 && column == 0;
}

std::string SourceLoc::to_string() const {
    if (empty()) {
        return "";
    }

    return g_strings.string(filename_id) + ":" +
           std::to_string(line) + ":" + std::to_string(column);
}

SourceLine::SourceLine(uint filename_id, size_t ln)
    : line(static_cast<uint32_t>(ln)),
      filename_id(static_cast<uint16_t>(filename_id)) {
}

SourceLine::SourceLine(std::string_view filename, size_t ln)
    : line(static_cast<uint32_t>(ln)),
      filename_id(static_cast<uint16_t>(g_strings.intern(filename))) {
}

SourceLine::SourceLine(const SourceLoc& loc)
    : line(loc.line),
      filename_id(loc.filename_id) {
}

bool SourceLine::operator==(const SourceLine& other) const  {
    return line == other.line && filename_id == other.filename_id;
}

bool SourceLine::operator!=(const SourceLine& other) const  {
    return !(*this == other);
}

size_t SourceLineHash::operator()(const SourceLine& s) const  {
    // Combine filename_id and line into a single 64-bit value
    uint64_t v = (uint64_t(s.filename_id) << 32) | s.line;
    return std::hash<uint64_t> {}(v);
}

