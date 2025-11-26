//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once
#include <string>
#include <vector>

struct Options {
    bool gen_dependencies = false;
    std::vector<std::string> input_files;

    bool parse_arg(const std::string& arg);
    void search_source_file(const std::string& filename);

    // manipulate filenames and paths
    std::string replace_extension(const std::string& filename,
                                  const std::string& extension);

    std::string get_asm_filename(const std::string& filename);
    std::string get_d_filename(const std::string& filename);
    std::string get_o_filename(const std::string& filename);
    std::string get_i_filename(const std::string& filename);

    bool is_asm_filename(const std::string& filename);
    bool is_o_filename(const std::string& filename);

private:
    bool is_option_arg(const std::string& arg,
                       const std::string& opt, std::string& opt_arg);
    std::string check_source(const std::string& filename);
};

extern Options g_options;

void exit_invalid_option(const std::string& option);
