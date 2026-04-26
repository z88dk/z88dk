//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cctype>
#include <string>
#include <string_view>

// Convert string to upper case
std::string to_lower(std::string_view s);
std::string to_upper(std::string_view s);

// trim whitspace at the beginnint and at the end
std::string trim(std::string_view s);

// check string ending
inline bool starts_with(std::string_view s, std::string_view prefix) {
    return s.size() >= prefix.size() &&
           s.compare(0, prefix.size(), prefix) == 0;
}

inline bool ends_with(std::string_view s, std::string_view suffix) {
    return s.size() >= suffix.size() &&
           s.compare(s.size() - suffix.size(), suffix.size(), suffix) == 0;
}

// escape special characters in a string for debug output
std::string escape_string(std::string_view s);

// Helper function to format integer as hex string
std::string int_to_hex(int value);

// safe ctype functions that work with signed char values
inline bool is_space(char c) {
    return std::isspace(static_cast<unsigned char>(c)) != 0;
}

inline bool is_alpha(char c) {
    return std::isalpha(static_cast<unsigned char>(c)) != 0;
}

inline bool is_dec_digit(char c) {
    return std::isdigit(static_cast<unsigned char>(c)) != 0;
}

inline bool is_hex_digit(char c) {
    return std::isxdigit(static_cast<unsigned char>(c)) != 0;
}

inline bool is_oct_digit(char c) {
    return c >= '0' && c <= '7';
}

inline bool is_bin_digit(char c) {
    return c == '0' || c == '1';
}

inline bool is_alnum(char c) {
    return std::isalnum(static_cast<unsigned char>(c)) != 0;
}

