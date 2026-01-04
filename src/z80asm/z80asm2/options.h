//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "cpu.h"
#include <cstdint>
#include <string>
#include <vector>

struct Options {
    bool verbose = false;
    bool ucase_labels = false;
    bool preprocess_only = false;
    bool swap_ix_iy = false;
    bool date_stamp = false;
    bool gen_dependencies = false;
    uint8_t filler_byte = 0x00;
    CPU cpu_id = CPU::z80;
    std::string m4_options;
    std::string perl_options;
    std::string cpp_options;
    std::string output_dir;
    std::vector<std::string> include_paths;
    std::vector<std::string> input_files;   // command line input files
    std::vector<std::string> object_files;  // output from the assembler

    // parse arguments and options
    bool parse_arg(const std::string& arg, bool& found_dash_dash);
    void search_source_file(const std::string& filename);
    void search_list_file(const std::string& list_filename);

    // manipulate filenames and paths
    std::string replace_extension(const std::string& filename,
                                  const std::string& extension);
    std::string prepend_output_dir(const std::string& filename);
    std::string resolve_include_candidate(const std::string& filename,
                                          const std::string& including_filename, bool is_angle = false);

    std::string get_asm_filename(const std::string& filename);
    std::string get_d_filename(const std::string& filename);
    std::string get_o_filename(const std::string& filename);
    std::string get_i_filename(const std::string& filename);

    bool is_asm_filename(const std::string& filename);
    bool is_o_filename(const std::string& filename);

private:
    bool is_option_arg(const std::string& arg,
                       const std::string& opt, std::string& opt_arg);
    bool is_const_expr_arg(const std::string& arg,
                           const std::string& opt, int& value);
    void run_m4(const std::string& filename);
    void run_perl(const std::string& filename);
    void run_cpp(const std::string& filename);
    std::string check_source(const std::string& filename);
};

extern Options g_options;

void exit_show_copyright(int exit_code);
void exit_show_usage(int exit_code);
void exit_invalid_option(const std::string& option);
