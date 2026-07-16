//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_data.h"
#include "binary_file.h"
#include <cmath>
#include <cstdlib>
#include <iomanip>
#include <memory>
#include <sstream>
#include <string>
#include <string_view>
#include <type_traits>
#include <unordered_map>
#include <vector>
#include <ios>

//-----------------------------------------------------------------------------
// String interner
//-----------------------------------------------------------------------------

class StringId {
public:
    explicit StringId() = default;
    explicit StringId(uint32_t id) : id_(id) {}

    void clear() {
        id_ = 0;
    }
    bool empty() const {
        return id_ == 0;
    }
    uint32_t id() const {
        return id_;
    }

    bool operator==(const StringId& other) const {
        return id_ == other.id_;
    }
    bool operator!=(const StringId& other) const {
        return id_ != other.id_;
    }

private:
    uint32_t id_ = 0;
};

class StringTable {
public:
    explicit StringTable();
    void clear();
    size_t size() const {
        return pool_.size();
    }
    StringId intern(std::string_view s);
    std::string_view view(StringId id) const;
    std::string_view operator[](StringId id) const;

    // pack to a binary data
    void pack(BinaryData& bin_data) const;

    // unpack from binary file
    void unpack(std::shared_ptr<const BinaryFile> file, size_t ptr);

private:
    std::vector<std::string> pool_;
    std::unordered_map<std::string, uint32_t> map_;
};

// Hash function for StringId to enable use as unordered_map key
namespace std {
template <>
struct hash<StringId> {
    std::size_t operator()(const StringId& id) const noexcept {
        return std::hash<uint32_t> {}(id.id());
    }
};
}

extern StringTable g_strings;

//-----------------------------------------------------------------------------
// Formating integers as hexadecimal strings
//-----------------------------------------------------------------------------

// format an integer as a hexadecimal string with optional width and leading zeros
template <typename T>
std::string int_to_hex(T value, size_t width = 2) {
    std::ostringstream oss;
    if constexpr (std::is_unsigned_v<T>) {
        // Unsigned type: never negative, no abs() needed
        if (value < 10) {
            oss << static_cast<unsigned>(value);
        }
        else {
            oss << "$" << std::uppercase << std::hex
                << std::setfill('0') << std::setw(width)
                << static_cast<unsigned>(value);
        }
    }
    else {
        // Signed type: handle negative values
        if (abs(value) < 10) {
            oss << static_cast<int>(value);
        }
        else if (value < 0) {
            oss << "-$" << std::uppercase << std::hex
                << std::setfill('0') << std::setw(width)
                << static_cast<unsigned>(-value);
        }
        else {
            oss << "$" << std::uppercase << std::hex
                << std::setfill('0') << std::setw(width)
                << static_cast<unsigned>(value);
        }
    }
    return oss.str();
}
