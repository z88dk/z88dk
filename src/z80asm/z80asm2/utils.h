//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cctype>
#include <string>
#include <vector>

// Convert string to upper/lower case
std::string to_upper(const std::string& s);
std::string to_lower(const std::string& s);

// trim whitspace at the beginnint and at the end
std::string ltrim(const std::string& s);
std::string rtrim(const std::string& s);
std::string trim(const std::string& s);

inline bool is_space(char c) {
    return std::isspace(static_cast<unsigned char>(c));
}

inline bool is_hex_char(char c) {
    return std::isxdigit(static_cast<unsigned char>(c));
}

inline bool is_dec_char(char c) {
    return std::isdigit(static_cast<unsigned char>(c));
}

inline bool is_bin_char(char c) {
    return c == '0' || c == '1';
}

inline bool is_ident_char(char c) {
    return c == '_' || c == '@' || std::isalnum(static_cast<unsigned char>(c));
}

// check string ending
bool str_ends_with(const std::string& str, const std::string& ending);
bool str_starts_with(const std::string& str, const std::string& beginning);

// convert string to C-style escaped string
std::string escape_c_string(const std::string& s);

// convert C-style escaped string back to raw bytes
// (accepts with or without surrounding quotes)
std::string unescape_c_string(const std::string& s);

// convert string to int of given base (2..36), returns false on error
bool parse_int_from_chars(const std::string& s, int base, int& out);
bool parse_float_from_chars(const std::string& s, double& out);

// read/write whole file to/from a string (throws std::runtime_error on error)
std::string read_file_to_string(const std::string& filename);
void write_string_to_file(const std::string& filename,
                          const std::string& content);

// read/write binary file to/from a vector of bytes (throws std::runtime_error on error)
std::vector<unsigned char> read_file_to_bytes(const std::string& filename);
void write_bytes_to_file(const std::string& filename,
                         const std::vector<unsigned char>& bytes);

// normalize path lexicographically (resolves . and .., removes redundant separators)
// returns platform-independent string with forward slashes
std::string normalize_path(const std::string& path);

// return parent directory of path, empty string if none
std::string parent_dir(const std::string& path);

// convert path to absolute path (throws std::runtime_error on error)
// returns platform-independent string with forward slashes
std::string absolute_path(const std::string& path);

// split lines of a text into a vector of strings
// accept LF, CR and CR-LF as line endings
std::vector<std::string> split_lines(const std::string& text);

// Helper: get environment variable value in a secure, cross-platform way.
// Returns empty string if the variable is not set.
std::string get_env_value(const std::string& name);

// Expand environment variables: replaces ${VAR} with getenv("VAR") or "" if unset.
// Supports nesting like ${var${param}} by recursively expanding inside names and values.
std::string expand_env_vars(const std::string& text);


