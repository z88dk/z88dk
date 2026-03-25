//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cctype>
#include <string>
#include <string_view>

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

