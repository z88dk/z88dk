//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "source_loc.h"
#include <string>
#include <vector>

struct Options {
    bool verbose = false;
    bool ucase_labels = false;
    bool preprocess_only = false;
    bool swap_ix_iy = false;
    bool date_stamp = false;
    std::string m4_options;
    std::string perl_options;
    std::string cpp_options;
    std::string output_dir;
    std::vector<std::string> include_paths;
};

extern Options g_options;
extern std::vector<std::string> g_input_files;   // command line input files

bool is_asm_filename(const std::string& filename);
bool is_o_filename(const std::string& filename);
std::string get_asm_filename(const std::string& filename);
std::string get_o_filename(const std::string& filename);

// Try candidates according to include semantics and include_paths,
// return resolved path if found or empty string if not found.
// including_filename: the file which contains the include directive (can be empty if unknown)
std::string resolve_include_candidate(const std::string& filename,
                                      const std::string& including_filename, bool is_angle);

// parse arguments and options
bool parse_arg(const std::string& arg, bool& found_dash_dash);
void search_source_file(const std::string& filename, const SourceLoc& loc = SourceLoc());

void exit_show_copyright(int exit_code);
void exit_show_usage(int exit_code);
void exit_invalid_option(const std::string& option);
