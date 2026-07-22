//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm_driver.h"
#include "diag.h"
#include "environment.h"
#include "linker.h"
#include "options.h"
#include "options_dump.h"
#include "source_loc.h"
#include <filesystem>
#include <iostream>
#include <sstream>
#include <string>
#include <string_view>

static constexpr std::string_view z80asm_env = "Z80ASM";

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
    g_args.define_constants_from_options();

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

    // assemble each input file
    assemble_files(g_args.input_files, g_args.options.output_dir);

    // link if requested
#if 0
    if (g_args.options.do_link) {
        link_files(g_args.input_files,
                   g_args.options.libs,
                   g_args.options.library_paths,
                   g_args.options.output_dir);
    }
#endif

    if (g_args.options.verbose) {
        auto errors = g_diag.get_error_count();
        std::cout << "Assembly completed with " << errors <<
                  " " << (errors == 1 ? "error" : "errors") << std::endl;
    }

    // if preprocess-only, exit
    if (g_args.options.preprocess_only) {
        return g_diag.get_error_count() ? EXIT_FAILURE : EXIT_SUCCESS;
    }

    return g_diag.get_error_count() ? EXIT_FAILURE : EXIT_SUCCESS;
}
