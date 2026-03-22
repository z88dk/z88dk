//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cstdint>
#include <string>
#include <string_view>

// all strings stored in g_strings for memory efficiency and fast comparisons

// field order for efficient packing into 8 bytes (64 bits):
struct SourceLoc {
    uint32_t line = 0;      // 4 bytes
    uint16_t file_id = 0;   // 2 bytes
    uint16_t column = 0;    // 2 bytes

    SourceLoc() = default;
    SourceLoc(int file, int ln, int col);
    SourceLoc(const std::string_view file, int ln, int col);

    static SourceLoc make(const std::string_view file, int line, int column);

    bool empty() const;
    std::string to_string() const;
};
