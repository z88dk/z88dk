//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "binary_data.h"
#include "diag.h"
#include "release_assert.h"
#include <fstream>

const uint8_t* BinaryData::data() const {
    return bytes.data();
}

size_t BinaryData::size() const {
    return bytes.size();
}

void BinaryData::align(size_t alignment) {
    size_t pad = align_up(bytes.size(), alignment) - bytes.size();
    bytes.insert(bytes.end(), pad, 0);
}

void BinaryData::put_data(const uint8_t* data, size_t size) {
    bytes.insert(bytes.end(), data, data + size);
}

void BinaryData::put_byte(uint8_t value) {
    bytes.push_back(value);
}

void BinaryData::put_word(uint16_t value) {
    bytes.push_back(static_cast<uint8_t>(value & 0xFF));
    bytes.push_back(static_cast<uint8_t>((value >> 8) & 0xFF));
}

void BinaryData::put_dword(uint32_t value) {
    bytes.push_back(static_cast<uint8_t>(value & 0xFF));
    bytes.push_back(static_cast<uint8_t>((value >> 8) & 0xFF));
    bytes.push_back(static_cast<uint8_t>((value >> 16) & 0xFF));
    bytes.push_back(static_cast<uint8_t>((value >> 24) & 0xFF));
}

void BinaryData::patch_dword(size_t offset, uint32_t value) {
    put_dword_at(offset, value);
}

void BinaryData::put_dword_at(size_t& ptr, uint32_t value) {
    release_assert(ptr + sizeof(uint32_t) <= bytes.size());
    bytes[ptr++] = static_cast<uint8_t>(value & 0xFF);
    bytes[ptr++] = static_cast<uint8_t>((value >> 8) & 0xFF);
    bytes[ptr++] = static_cast<uint8_t>((value >> 16) & 0xFF);
    bytes[ptr++] = static_cast<uint8_t>((value >> 24) & 0xFF);
}

void BinaryData::put_string(std::string_view str) {
    bytes.insert(bytes.end(), str.begin(), str.end());
}

void BinaryData::put_byte_string(std::string_view str) {
    release_assert(str.size() <= 255);
    put_byte(static_cast<uint8_t>(str.size()));
    put_string(str);
}

void BinaryData::put_word_string(std::string_view str) {
    release_assert(str.size() <= 65535);
    put_word(static_cast<uint16_t>(str.size()));
    put_string(str);
}

void BinaryData::write_to_file(std::string_view filename) const {
    std::ofstream file(std::string(filename), std::ios::binary);
    if (!file.is_open()) {
        fatal_error("failed to open file: " + std::string(filename));
    }

    file.write(reinterpret_cast<const char*>(bytes.data()), bytes.size());
    if (!file.good()) {
        fatal_error("failed to write to file: " + std::string(filename));
    }
}
