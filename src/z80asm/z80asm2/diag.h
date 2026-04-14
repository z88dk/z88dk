//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "source_loc.h"
#include <string_view>
#include <unordered_map>

class Diagnostics {
public:
    void error(const SourceLoc& loc, std::string_view msg);
    void warning(const SourceLoc& loc, std::string_view msg);
    void note(const SourceLoc& loc, std::string_view msg);

    void add_mapping(const SourceLine& logical_line,
                     const SourceLine& physical_loc);
    size_t get_error_count() const;

private:
    size_t error_count = 0;
    std::unordered_map<SourceLine, SourceLine, SourceLineHash> line_mappings;

    void print_message(const SourceLoc& loc,
                       std::string_view level,
                       std::string_view msg);
    void print_source_line(std::string_view text, size_t column);
};

extern Diagnostics g_diag;
