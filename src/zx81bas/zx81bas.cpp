//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../config.h"
#include "ast.h"
#include "errors.h"
#include "lexer.h"
#include "lower_asm.h"
#include "lower_bas.h"
#include "options.h"
#include "parser.h"
#include "preproc.h"
#include "semantic.h"
#include "symtab.h"
#include "utils.h"
#include "z80asm.h"
#include <cstdlib>
#include <filesystem>
#include <iostream>
#include <memory>
#include <string>
#include <vector>

static const std::string COPYRIGHT =
    "Copyright (C) Paulo Custodio 2023-2026\n"
#ifdef Z88DK_VERSION
    "Version: " Z88DK_VERSION "\n"
#endif
    ;

static void show_usage(const char* prog_name) {
    std::string cmd = std::filesystem::path(prog_name).stem().generic_string();
    std::cout << COPYRIGHT;
    std::cout << "Usage: " << cmd << " [options] file.bas" << std::endl;
    std::cout << "Options:" << std::endl;
    std::cout <<
              "  -o <file>    Specify output file (default: input with .p extension)" <<
              std::endl;
    std::cout << "  -k           Keep temporary files (for debugging)" << std::endl;
    std::cout << "  -h           Show this help message" << std::endl;
    std::cout << "  -v           Verbose mode" << std::endl;
#ifdef _DEBUG
    std::cout << "  -d <step>    Dump and exit at given step" << std::endl;
#endif
}

#ifdef _DEBUG
static void show_command_line(int argc, char* argv[]) {
    std::string cmd = std::filesystem::path(argv[0]).stem().generic_string();
    std::cout << "% " << cmd;
    for (int i = 1; i < argc; ++i) {
        std::cout << " " << argv[i];
    }
    std::cout << std::endl;
}
#endif

static void delete_temporary_files() {
    if (!g_keep_temp_files) {
        for (auto& f : g_temp_files) {
            remove_file(f);
        }
    }
}

int main(int argc, char* argv[]) {
    std::string output_file;
    g_verbose = false;
    int opt;

    // cleanup temporary files on exit (except -k)
    atexit(delete_temporary_files);

#ifdef _DEBUG
    g_verbose = true;
    show_command_line(argc, argv);
#endif

    if (argc == 1) {
        show_usage(argv[0]);
        return EXIT_SUCCESS;
    }

    // parse options
    while ((opt = simple_getopt(argc, argv, "o:khvd:?")) != -1) {
        switch (opt) {
        case 'o':
            output_file = normalize_path(g_optarg);
            break;
        case 'h':
            show_usage(argv[0]);
            return EXIT_SUCCESS;
        case 'v':
            g_verbose = true;
            break;
        case 'k':
            g_keep_temp_files = true;
            break;
#ifdef _DEBUG
        case 'd':
            g_dump_step = std::stoi(g_optarg);
            break;
#endif
        case '?':
            show_usage(argv[0]);
            return EXIT_FAILURE;
        default:
            show_usage(argv[0]);
            return EXIT_FAILURE;
        }
    }

    // check for input file
    if (g_optind >= argc) {
        error("No input file specified");
        show_usage(argv[0]);
        return EXIT_FAILURE;
    }

    // input file
    std::string input_file = normalize_path(argv[g_optind]);
    if (str_ends_with(input_file, ".p")) {
        error("Input file cannot have .p extension: " + input_file);
        return EXIT_FAILURE;
    }
    std::string input_basename = std::filesystem::path(input_file)
                                 .replace_extension("")
                                 .generic_string();

    // output file
    if (output_file.empty()) {
        output_file = input_basename + ".p";
    }

    if (g_verbose) {
        std::cout << "Input file:  " << input_file << std::endl;
        std::cout << "Output file: " << output_file << std::endl;
    }

    // preprocess the input file
    std::vector<SrcLine> src_lines;
    if (!preproc(input_file, input_basename, src_lines)) {
        exit_error_status();
    }

    // tokenize the preprocessed lines
    TokFile tok_file;
    if (!tok_file.tokenize(src_lines)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 4) {
        if (get_error_count() == 0) {
            std::cout << "Tokenized input:" << std::endl;
            DumpContext ctx(std::cout);
            tok_file.dump(ctx);
        }
        exit_error_status();
    }
#endif

    // parse the BASIC program
    std::unique_ptr<Prog> prog;
    if (!parse_basic_program(tok_file, prog)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 5) {
        if (get_error_count() == 0) {
            DumpContext ctx(std::cout);
            prog->dump(ctx);
        }
        exit_error_status();
    }
#endif

    // symbol table collection
    std::unique_ptr<Symtab> symtab;
    if (!create_symtab(*prog, symtab)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 6) {
        if (get_error_count() == 0) {
            DumpContext ctx(std::cout);
            symtab->dump(ctx);
        }
        exit_error_status();
    }
#endif

    // semantic check
    if (!semantic_check(*prog)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 7) {
        if (get_error_count() == 0) {
            DumpContext ctx(std::cout);
            prog->dump(ctx);
        }
        exit_error_status();
    }
#endif

    // lower to standard BASIC
    if (!lower_prog(*prog, *symtab)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 8) {
        if (get_error_count() == 0) {
            DumpContext ctx(std::cout);
            prog->dump(ctx);
        }
        exit_error_status();
    }
#endif

    // build assembly source
    std::vector<std::string> asm_source;
    if (!build_asm_source(*prog, *symtab, asm_source)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 9) {
        if (get_error_count() == 0) {
            for (auto& text : asm_source) {
                std::cout << text << std::endl;
            }
        }
        exit_error_status();
    }
#endif

    // call the assembler and linker to produce .P and .sym file
    std::string asm_file = input_basename + ".asm";
    std::string sym_file = input_basename + ".sym";
    std::string p_file = input_basename + ".p";
    g_temp_files.push_back(asm_file);
    if (!assemble_link(asm_source, asm_file, sym_file, p_file)) {
        exit_error_status();
    }

    // exit with error status
    exit_error_status();
}
