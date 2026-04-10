//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "source_loc.h"
#include "string_interner.h"
#include <cstdint>
#include <string>

SourceLoc::SourceLoc(StringInterner::Id file, size_t ln, size_t col)
    : line(static_cast<uint32_t>(ln)),
      file_id(static_cast<uint16_t>(file)),
      column(static_cast<uint16_t>(col)) {
}

SourceLoc::SourceLoc(std::string_view file, size_t ln, size_t col)
    : line(static_cast<uint32_t>(ln)),
      file_id(static_cast<uint16_t>(g_strings.intern(file))),
      column(static_cast<uint16_t>(col)) {
}

void SourceLoc::clear() {
    file_id = 0;
    line = 0;
    column = 0;
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

SourceLine::SourceLine(StringInterner::Id file, size_t ln)
    : line(static_cast<uint32_t>(ln)),
      file_id(static_cast<uint16_t>(file)) {
}

SourceLine::SourceLine(std::string_view file, size_t ln)
    : line(static_cast<uint32_t>(ln)),
      file_id(static_cast<uint16_t>(g_strings.intern(file))) {
}

SourceLine::SourceLine(const SourceLoc& loc)
    : line(loc.line),
      file_id(loc.file_id) {
}

bool SourceLine::operator==(const SourceLine& other) const noexcept {
    return line == other.line && file_id == other.file_id;
}

bool SourceLine::operator!=(const SourceLine& other) const noexcept {
    return !(*this == other);
}

size_t SourceLineHash::operator()(const SourceLine& s) const noexcept {
    // Combine file_id and line into a single 64-bit value
    uint64_t v = (uint64_t(s.file_id) << 32) | s.line;
    return std::hash<uint64_t> {}(v);
}

