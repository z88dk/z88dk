//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "source_loc.h"
#include "strings.h"
#include <cstdint>
#include <string>

SourceLoc::SourceLoc(StringId filename_id, uint line, uint column)
    : filename_id_(filename_id),
      line_(line),
      column_(column) {
}

SourceLoc::SourceLoc(std::string_view filename, uint line, uint column)
    : SourceLoc(g_strings.intern(filename), line, column) {
}

void SourceLoc::clear() {
    filename_id_.clear();
    line_ = 0;
    column_ = 0;
}

bool SourceLoc::empty() const {
    return filename_id_.empty() && line_ == 0;
}

std::string SourceLoc::to_string() const {
    if (empty()) {
        return "";
    }

    return std::string(g_strings.view(filename_id_)) + ":" +
           std::to_string(line_) + ":" + std::to_string(column_);
}

SourceLine::SourceLine(StringId filename_id, uint line)
    : line_(line),
      filename_id_(filename_id) {
}

SourceLine::SourceLine(std::string_view filename, uint line)
    : SourceLine(g_strings.intern(filename), line) {
}

SourceLine::SourceLine(const SourceLoc& loc)
    : line_(loc.line()),
      filename_id_(loc.filename_id()) {
}

bool SourceLine::operator==(const SourceLine& other) const  {
    return line_ == other.line_ && filename_id_ == other.filename_id_;
}

bool SourceLine::operator!=(const SourceLine& other) const  {
    return !(*this == other);
}

size_t SourceLineHash::operator()(const SourceLine& s) const  {
    // Combine filename_id and line into a single 64-bit value
    uint64_t v = (uint64_t(s.filename_id().id()) << 32) | s.line();
    return std::hash<uint64_t> {}(v);
}

