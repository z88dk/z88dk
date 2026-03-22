//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cctype>
#include <string>
#include <string_view>

// Convert string to upper/lower case
std::string to_upper(const std::string_view s);
std::string to_lower(const std::string_view s);

// trim whitspace at the beginnint and at the end
std::string ltrim(const std::string_view s);
std::string rtrim(const std::string_view s);
std::string trim(const std::string_view s);

// check string ending
inline bool starts_with(std::string_view s, std::string_view prefix) {
    return s.size() >= prefix.size() &&
           s.compare(0, prefix.size(), prefix) == 0;
}

inline bool ends_with(std::string_view s, std::string_view suffix) {
    return s.size() >= suffix.size() &&
           s.compare(s.size() - suffix.size(), suffix.size(), suffix) == 0;
}

// normalize path lexicographically (resolves . and .., removes redundant
// separators)
// returns platform-independent string with forward slashes
std::string normalize_path(const std::string_view path);

// return parent directory of path, empty string if none
std::string parent_dir(const std::string_view path);

// replace file extension with new extension, or add it if none
std::string replace_extension(const std::string_view filename, const std::string_view extension);

// preprend output directory to filename if output directory is set, otherwise return filename
std::string prepend_output_dir(const std::string_view filename, const std::string_view output_dir);

// Helper: get environment variable value in a secure, cross-platform way.
// Returns empty string if the variable is not set.
std::string get_env_value(const std::string_view name);

// Expand environment variables: replaces ${VAR} with getenv("VAR") or "" if unset.
// Supports nesting like ${var${param}} by recursively expanding inside names and values.
std::string expand_env_vars(const std::string_view text);

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

