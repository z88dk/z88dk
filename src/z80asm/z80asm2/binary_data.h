//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cstdint>
#include <string_view>
#include <vector>

inline size_t align_up(size_t value, size_t alignment) {
    return (value + alignment - 1) & ~(alignment - 1);
}

// binary data for object and library files
// allow creation of object and library files in memory and write them to disk
struct BinaryData {
    std::vector<uint8_t> bytes;   // binary data

    BinaryData() = default;

    const uint8_t* data() const;
    size_t size() const;
    void align(size_t alignment = 4);
    void put_data(const uint8_t* data, size_t size);
    void put_byte(uint8_t value);
    void put_word(uint16_t value);
    void put_dword(uint32_t value);
    void put_string(std::string_view str);
    void put_byte_string(std::string_view str);
    void put_word_string(std::string_view str);

    void patch_dword(size_t offset, uint32_t value);
    void put_dword_at(size_t& ptr, uint32_t value);

    void write_to_file(std::string_view filename) const;
};
