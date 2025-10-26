//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "options.h"
#include "preprocessor.h"
#include <iostream>

static bool is_option_arg(const std::string& arg,
                          const std::string& option, std::string& option_arg) {
    option_arg.clear();

    if (arg.size() > option.size() &&
            arg.substr(0, option.size()) == option) {
        option_arg = arg.substr(option.size());
        if (!option_arg.empty() && option.front() == '=') {
            option_arg = option_arg.substr(1);
        }
    }

    return !option_arg.empty();
}

int main(int argc, char* argv[]) {
    // process command-line arguments
    bool found_dash_dash = false;
    if (argc == 1) {
        exit_show_copyright(EXIT_FAILURE);
    }
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        std::string option_arg;

        if (arg.empty()) {
            // skip empty args
        }
        else if (!found_dash_dash && arg[0] == '-') {
            // options
            switch (arg[1]) {
            case '-':
                if (arg == "--") {
                    found_dash_dash = true;
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            case 'E':
                if (arg == "-E") {
                    g_options.preprocess_only = true;
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            case 'I':
                if (arg == "-IXIY") {
                    g_options.swap_ix_iy = true;
                }
                else if (is_option_arg(arg, "-I", option_arg)) {
                    g_options.include_paths.push_back(option_arg);
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            case 'O':
                if (is_option_arg(arg, "-O", option_arg)) {
                    g_options.output_dir = option_arg;
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            case 'd':
                if (arg == "-d") {
                    g_options.date_stamp = true;
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            case 'h':
                if (arg == "-h") {
                    exit_show_usage(EXIT_SUCCESS);
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            case 'm':
                if (is_option_arg(arg, "-m4", option_arg)) {
                    g_options.m4_options = option_arg;
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            case 'p':
                if (is_option_arg(arg, "-perl", option_arg)) {
                    g_options.perl_options = option_arg;
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            case 'u':
                if (arg == "-ucase") {
                    g_options.ucase_labels = true;
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            case 'v':
                if (arg == "-v") {
                    g_options.verbose = true;
                }
                else {
                    exit_invalid_option(arg);
                }
                break;
            default:
                exit_invalid_option(arg);
            }
        }
        else {
            // input file
            std::string source_file = search_source_file(arg);
            if (!source_file.empty()) {
                g_input_files.push_back(source_file);
            }
        }
    }

    // detect errors from argument processing
    if (g_errors.has_errors()) {
        return EXIT_FAILURE;
    }

    if (g_input_files.empty()) {
        g_errors.error(ErrorCode::NoInputFiles);
        exit(EXIT_FAILURE);
    }

    // execute requested actions
    if (g_options.preprocess_only) {
        //preprocess_only();
    }
    else {
        g_errors.error(ErrorCode::UnknownInstruction,
                       "Full assemble not implemented yet");
    }

    return g_errors.has_errors() ? EXIT_FAILURE : EXIT_SUCCESS;
}
