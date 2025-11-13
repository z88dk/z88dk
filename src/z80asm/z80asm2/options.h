//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once
#include <string>
#include <vector>

struct Options {
    bool verbose = false;
    bool ucase_labels = false;
    bool preprocess_only = false;
    bool swap_ix_iy = false;
    bool date_stamp = false;
    bool gen_dependencies = false;
    std::string m4_options;
    std::string perl_options;
    std::string output_dir;
    std::vector<std::string> include_paths;
};

extern Options g_options;
extern std::vector<std::string> g_input_files;

void exit_show_copyright(int exit_code);
void exit_show_usage(int exit_code);
void exit_invalid_option(const std::string& option);

// manipulate filenames and paths
std::string get_asm_filename(const std::string& filename);
std::string get_d_filename(const std::string& filename);
std::string get_o_filename(const std::string& filename);
std::string get_i_filename(const std::string& filename);

bool is_asm_filename(const std::string& filename);
bool is_o_filename(const std::string& filename);

std::string resolve_include_candidate(const std::string& filename,
                                      bool is_angle = false);
std::string search_source_file(const std::string& filename);



