//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "const_symbols.h"
#include "cpu.h"
#include "source_loc.h"
#include "zfloat.h"
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

// option types
enum class OptionType {
#define X(name, str, takes_arg, arg_text, usage) name,
#include "options.def"
};

// defaults
static constexpr CPU DEFAULT_CPU = CPU::z80;
static constexpr uint8_t DEFAULT_FILLER_BYTE = 0x00;
static constexpr FloatFormat DEFAULT_FLOAT_FORMAT = FloatFormat::genmath;

// option specification
struct OptionSpec {
    const char* name;
    OptionType  type;
    bool        takes_arg;
    const char* arg_text;
    const char* usage;
};

struct Options {
    bool verbose = false;
    bool ucase_symbols = false;
    bool preprocess_only = false;
    bool generate_dependencies = false;
    CPU  cpu_id{ DEFAULT_CPU }; // immutable, from -m
    bool swap_ix_iy = false;
    bool date_stamp = false;
    uint8_t filler_byte = DEFAULT_FILLER_BYTE;
    FloatFormat float_format = DEFAULT_FLOAT_FORMAT;
    bool do_link = false;
    bool dump_after_cmdline = false;
    bool dump_after_tokenization = false;
    bool dump_after_directives = false;
    bool dump_after_macro_expansion = false;
    bool dump_after_hla_expansion = false;
    bool dump_after_synth_expansion = false;
    bool dump_after_preprocessing = false;
    bool dump_after_parse = false;
    bool dump_after_symbol_collection = false;
    bool dump_after_layout = false;
    bool dump_after_assembly = false;
    bool dump_after_link_collection = false;
    std::string m4_options;
    std::string perl_options;
    std::string cpp_options;
    std::string output_dir;
    std::vector<std::string> include_paths;
    std::vector<std::string> library_paths;
    std::vector<std::string> libs;
    ConstSymbols global_defs;
};

struct Args {
    Options options;
    std::vector<std::string> input_files;   // command line input files

    // parse arguments and options
    void parse_arg(std::string_view arg,
                   bool& found_dash_dash, const SourceLoc& loc);
    void search_source_file(std::string_view filename,
                            std::string_view including_filename,
                            const SourceLoc& loc,
                            std::vector<SourceLoc>& loc_stack);
    // define variables from cpu and -IXIY options
    void define_constants_from_options();

private:
    bool split_option_arg(std::string_view arg,
                          std::string_view opt_name,
                          std::string& out);
    void append_with_space(std::string& dst, std::string_view src);
    void parse_define(std::string_view arg, std::string_view opt_name,
                      const SourceLoc& loc);
    void parse_filler_byte(std::string_view arg, std::string_view opt_name,
                           const SourceLoc& loc);
    const OptionSpec* match_option(std::string_view arg);
    std::string check_source(std::string_view filename);
    void search_list_file(std::string_view list_filename,
                          const SourceLoc& loc,
                          std::vector<SourceLoc>& loc_stack);
    bool parse_filename_entry(std::string_view line_,
                              SourceLoc& in_out_loc,
                              std::string& out_filename);
    void run_tool(std::string_view filename,
                  std::string_view extension,
                  std::string_view including_filename,
                  std::string_view tool_name_,
                  std::string_view tool_options,
                  const SourceLoc& loc,
                  std::vector<SourceLoc>& loc_stack);
    void run_m4(std::string_view filename,
                std::string_view including_filename,
                const SourceLoc& loc,
                std::vector<SourceLoc>& loc_stack);
    void run_perl(std::string_view filename,
                  std::string_view including_filename,
                  const SourceLoc& loc,
                  std::vector<SourceLoc>& loc_stack);
    void run_cpp(std::string_view filename,
                 std::string_view including_filename,
                 const SourceLoc& loc,
                 std::vector<SourceLoc>& loc_stack);
};

extern Args g_args;


[[noreturn]] void exit_show_copyright(int exit_code);
[[noreturn]] void exit_show_usage(int exit_code);
