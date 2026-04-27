//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "environment.h"
#include "hla.h"
#include "lexer_dump.h"
#include "lexer_tokens.h"
#include "opcodes.h"
#include "options.h"
#include "options_dump.h"
#include "pathnames.h"
#include "preproc.h"
#include "source_loc.h"
#include <cstdlib>
#include <filesystem>
#include <iostream>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

static constexpr std::string_view z80asm_env = "Z80ASM";

static void assemble_file(std::string_view filename) {
    if (g_args.options.verbose) {
        std::cout << "Assembling " << filename << "..." << std::endl;
    }

    // run tokenizer and cache tokens in SourceFile
    if (g_args.options.dump_after_tokenization) {
        dump_after_tokenization_and_exit(filename);
        // not reached
    }

    // run preprocessor and get final token stream
    Preproc preproc;
    preproc.set_const_symbols(g_args.options.global_defs);
    std::vector<LogicalLine> preprocessed_tokens = preproc.preprocess(filename);

    // process High-Level-Assembly instructions
    std::vector<LogicalLine> hla_lines = hla_process(preprocessed_tokens);
    if (g_args.options.dump_after_hla) {
        dump_after_hla_and_exit(hla_lines);
        // not reached
    }

    // process synthetic instructions and rewrite tokens
    // to their final form for the assembler
    std::vector<LogicalLine> asm_lines = synthetic_expand(hla_lines);
}

static void assemble_files() {
    for (const std::string& filename : g_args.input_files) {
        if (is_o_filename(filename)) {
            if (g_args.options.verbose) {
                std::cout << "Skipping object file " << filename
                          << "..." << std::endl;
            }
            g_args.obj_files.push_back(filename);
        }
        else {
            // assemble source file
            // will push resulting object file to g_args.obj_files
            assemble_file(filename);
        }
    }
}

static bool has_verbose(int argc, char* argv[]) {
    std::string env_options = get_env_value(z80asm_env);
    if (env_options.find("-v") != std::string::npos) {
        return true;
    }
    for (int i = 1; i < argc; ++i) {
        std::string arg(argv[i]);
        if (arg.find("-v") != std::string::npos) {
            return true;
        }
    }
    return false;
}

static void show_command_line(int argc, char* argv[]) {
    std::string env_options = get_env_value(z80asm_env);
    if (!env_options.empty()) {
        std::cout << z80asm_env << "=" << env_options << std::endl;
    }

    std::string cmd = std::filesystem::path(argv[0]).stem().generic_string();
    std::cout << "% " << cmd;
    for (int i = 1; i < argc; ++i) {
        std::cout << " " << argv[i];
    }
    std::cout << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc == 1) {
        exit_show_copyright(EXIT_SUCCESS);
    }

    // show command line if verbose
    if (has_verbose(argc, argv)) {
        g_args.options.verbose = true;
        show_command_line(argc, argv);
    }

    // process options from environment variable Z80ASM
    std::istringstream ss(get_env_value(z80asm_env));
    std::string arg;
    for (int i = 1; ss >> arg; ++i) {
        bool found_dash_dash = false;
        SourceLoc loc("<environment>", i, 1);
        g_args.parse_arg(arg, found_dash_dash, loc);
    }

    // process command line arguments
    bool found_dash_dash = false;
    for (int i = 1; i < argc; ++i) {
        SourceLoc loc("<command-line>", i, 1);
        g_args.parse_arg(argv[i], found_dash_dash, loc);
    }

    // define global defines from command line options
    g_args.define_constants_from_cpu_and_ixiy();

    if (g_args.options.dump_after_cmdline) {
        dump_after_cmdline_and_exit();
        // not reached
    }

    // detect errors from argument processing
    if (g_diag.get_error_count()) {
        return EXIT_FAILURE;
    }

    if (g_args.input_files.empty()) {
        g_diag.error(SourceLoc("<command-line>", 0, 0), "No input files specified");
        return EXIT_FAILURE;
    }

    // execute requested actions
    assemble_files();

    if (g_args.options.verbose) {
        std::cout << "Assembly completed with " << g_diag.get_error_count() << " error(s)" << std::endl;
    }

    return g_diag.get_error_count() ? EXIT_FAILURE : EXIT_SUCCESS;
}
