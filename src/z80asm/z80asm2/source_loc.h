//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "string_interner.h"
#include <cstdint>
#include <string>
#include <string_view>

// field order for efficient packing into 8 bytes (64 bits):
struct SourceLoc {
    uint32_t line = 0;      // 4 bytes
    uint16_t file_id = 0;   // 2 bytes
    uint16_t column = 0;    // 2 bytes

    SourceLoc() = default;
    SourceLoc(StringInterner::Id file, size_t ln, size_t col);
    SourceLoc(std::string_view file, size_t ln, size_t col);

    void clear();
    bool empty() const;
    std::string to_string() const;
};

// used to map physical to logical lines
struct SourceLine {
    uint32_t line = 0;      // 4 bytes
    uint16_t file_id = 0;   // 2 bytes

    SourceLine() = default;
    SourceLine(StringInterner::Id file, size_t ln);
    SourceLine(std::string_view file, size_t ln);
    SourceLine(const SourceLoc& loc);

    bool operator==(const SourceLine& other) const noexcept;
    bool operator!=(const SourceLine& other) const noexcept;
};

struct SourceLineHash {
    size_t operator()(const SourceLine& s) const noexcept;
};

