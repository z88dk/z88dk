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
    bool preprocess_only = false;
    bool gen_dependencies = false;
    uint8_t filler_byte = 0x00;
    CPU cpu_id = CPU::z80;
    std::string output_dir;
    std::vector<std::string> include_paths;
    std::vector<std::string> input_files;   // command line input files
    std::vector<std::string> object_files;  // output from the assembler

    // parse arguments and options
    bool parse_arg(const std::string& arg);
    void search_source_file(const std::string& filename);

    // manipulate filenames and paths
    std::string replace_extension(const std::string& filename,
                                  const std::string& extension);
    std::string prepend_output_dir(const std::string& filename);
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
};

extern Options g_options;
