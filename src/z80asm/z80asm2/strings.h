//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cstdint>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

class StringInterner {
public:
    using Id = uint32_t;

    // Reserve ID 0 for the empty string
    StringInterner();

    // Returns an ID for the given string, interning it if needed.
    Id intern(std::string_view s);

    // Get C-string for an ID (stable pointer).
    const char* c_str(Id id) const;

    // Get string_view for an ID.
    std::string_view view(Id id) const;

    // Get std::string for an ID.
    std::string to_string(Id id) const;

    // Optional: number of unique strings.
    uint32_t size() const noexcept;

private:
    std::vector<std::string> pool;
    std::unordered_map<std::string, Id> map;
};

extern StringInterner g_strings;
