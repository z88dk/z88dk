//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <string_view>
#include <vector>

// file extensions
static constexpr std::string_view asm_extension = ".asm";
static constexpr std::string_view o_extension = ".o";
static constexpr std::string_view m4_extension = ".m4";
static constexpr std::string_view perl_extension = ".pl";
static constexpr std::string_view cpp_extension = ".cpp";

bool is_asm_filename(std::string_view filename);
bool is_o_filename(std::string_view filename);

std::string get_asm_filename(std::string_view filename);
std::string get_o_filename(std::string_view filename,
                           std::string_view output_dir);

// normalize path lexicographically (resolves . and .., removes redundant
// separators)
// returns platform-independent string with forward slashes
std::string normalize_path(std::string_view path);

// return parent directory of path, empty string if none
std::string parent_dir(std::string_view path);

// replace file extension with new extension, or add it if none
std::string replace_extension(std::string_view filename,
                              std::string_view extension);

// prepend output directory to filename if output directory is set,
// otherwise return filename
std::string prepend_output_dir(std::string_view filename,
                               std::string_view output_dir);

// Try candidates according to include semantics and include_paths,
// return resolved path if found or empty string if not found.
// including_filename: the file which contains the include directive
// (can be empty if unknown)
std::string resolve_include_candidate(std::string_view filename,
                                      std::string_view including_filename,
                                      bool is_angle,
                                      const std::vector<std::string>& include_paths);

// Does the pattern contain any wildcard characters?
bool has_wildcards(std::string_view pat);

// Expand wildcards using std::filesystem only: supports '*', '?', and '**'
std::vector<std::string> expand_wildcards(std::string_view pattern);
