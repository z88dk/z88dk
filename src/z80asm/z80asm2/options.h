//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "const_expr.h"
#include "source_loc.h"
#include <string>
#include <vector>

struct Options {
    bool verbose = false;
    bool ucase_labels = false;
    bool preprocess_only = false;
    bool swap_ix_iy = false;
    bool date_stamp = false;
    bool dump_after_cmdline = false;
    bool dump_after_tokenization = false;
    std::string m4_options;
    std::string perl_options;
    std::string cpp_options;
    std::string output_dir;
    std::vector<std::string> include_paths;
    ConstSymbols global_defs;
};

struct Args {
    Options options;
    std::vector<std::string> input_files;   // command line input files
};

extern Args g_args;

// parse arguments and options
bool parse_arg(const std::string_view arg, bool& found_dash_dash);
void search_source_file(const std::string_view filename, const SourceLoc& loc);

[[noreturn]] void exit_show_copyright(int exit_code);
[[noreturn]] void exit_show_usage(int exit_code);
[[noreturn]] void exit_invalid_option(const std::string_view option);
