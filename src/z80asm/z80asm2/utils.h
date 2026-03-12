//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

// global string pool
// reuse string literals to save memory and speed up comparisons
const char* strpool(const std::string& str);

// Convert string to upper/lower case
std::string to_upper(const std::string& s);
std::string to_lower(const std::string& s);

// check string ending
bool str_ends_with(const std::string& str, const std::string& ending);
bool str_starts_with(const std::string& str, const std::string& beginning);

// normalize path lexicographically (resolves . and .., removes redundant
// separators)
// returns platform-independent string with forward slashes
std::string normalize_path(const std::string& path);

// return parent directory of path, empty string if none
std::string parent_dir(const std::string& path);

