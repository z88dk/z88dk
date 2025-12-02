//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "options.h"
#include "preprocessor.h"
#include "utils.h"
#include <filesystem>
#include <iostream>
#include <sstream>

const std::string z80asm_env = "Z80ASM";

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
        exit_show_copyright(EXIT_FAILURE);
    }

    // show command line if verbose
    if (has_verbose(argc, argv)) {
        show_command_line(argc, argv);
    }

    // process options from environment variable Z80ASM
    std::istringstream ss(get_env_value(z80asm_env));
    std::string arg;
    while (ss >> arg) {
        bool found_dash_dash = false;
        if (!g_options.parse_arg(arg, found_dash_dash)) {
            exit_invalid_option(arg);
        }
    }

    // process command line arguments
    bool found_dash_dash = false;
    for (int i = 1; i < argc; ++i) {
        if (!g_options.parse_arg(argv[i], found_dash_dash)) {
            exit_invalid_option(argv[i]);
        }
    }

    // detect errors from argument processing
    if (g_errors.has_errors()) {
        return EXIT_FAILURE;
    }

    if (g_options.input_files.empty()) {
        g_errors.error(ErrorCode::NoInputFiles);
        exit(EXIT_FAILURE);
    }

    // execute requested actions
    if (g_options.preprocess_only) {
        preprocess_only();
    }
    else {
        g_errors.error(ErrorCode::UnknownInstruction,
                       "Full assemble not implemented yet");
    }

    return g_errors.has_errors() ? EXIT_FAILURE : EXIT_SUCCESS;
}
