//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <cctype>
#include <vector>

// global string pool
// reuse string literals to save memory and speed up comparisons
const char* strpool(const std::string& str);

// safe ctype functions that work with signed char values
inline bool is_space(char c) {
    return std::isspace(static_cast<unsigned char>(c)) != 0;
}

inline bool is_alpha(char c) {
    return std::isalpha(static_cast<unsigned char>(c)) != 0;
}

inline bool is_digit(char c) {
    return std::isdigit(static_cast<unsigned char>(c)) != 0;
}

inline bool is_hex_digit(char c) {
    return std::isxdigit(static_cast<unsigned char>(c)) != 0;
}

inline bool is_bin_digit(char c) {
    return c == '0' || c == '1';
}

inline bool is_alnum(char c) {
    return std::isalnum(static_cast<unsigned char>(c)) != 0;
}

// identifier character: letter, digit, or underscore
inline bool is_ident_start(char c) {
    return is_alpha(c) || c == '_';
}

inline bool is_ident_char(char c) {
    return is_alpha(c) || is_digit(c) || c == '_';
}

// Convert string to upper/lower case
std::string to_upper(const std::string& s);
std::string to_lower(const std::string& s);

// trim whitspace at the beginnint and at the end
std::string ltrim(const std::string& s);
std::string rtrim(const std::string& s);
std::string trim(const std::string& s);

// check string ending
bool str_ends_with(const std::string& str, const std::string& ending);
bool str_starts_with(const std::string& str, const std::string& beginning);

// normalize path lexicographically (resolves . and .., removes redundant
// separators)
// returns platform-independent string with forward slashes
std::string normalize_path(const std::string& path);

// return parent directory of path, empty string if none
std::string parent_dir(const std::string& path);

// replace file extension with new extension, or add it if none
std::string replace_extension(const std::string& filename, const std::string& extension);

// preprend output directory to filename if output directory is set, otherwise return filename
std::string prepend_output_dir(const std::string& filename, const std::string& output_dir);

// Helper: get environment variable value in a secure, cross-platform way.
// Returns empty string if the variable is not set.
std::string get_env_value(const std::string& name);

// Expand environment variables: replaces ${VAR} with getenv("VAR") or "" if unset.
// Supports nesting like ${var${param}} by recursively expanding inside names and values.
std::string expand_env_vars(const std::string& text);

