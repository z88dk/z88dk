//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cstdint>
#include <string>
#include <string_view>

// field order for efficient packing into 8 bytes (64 bits):
struct SourceLoc {
    uint32_t line = 0;      // 4 bytes
    uint16_t file_id = 0;   // 2 bytes
    uint16_t column = 0;    // 2 bytes

    SourceLoc() = default;
    SourceLoc(int file, size_t ln, size_t col);
    SourceLoc(const std::string_view file, size_t ln, size_t col);

    static SourceLoc make(const std::string_view file,
                          size_t line, size_t column);
    bool empty() const;
    std::string to_string() const;
};
