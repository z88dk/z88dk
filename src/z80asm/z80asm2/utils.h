//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <vector>

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

// convert string to C-style escaped string
std::string escape_string(const std::string& s);

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

