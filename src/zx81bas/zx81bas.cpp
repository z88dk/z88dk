//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../config.h"
#include "assemble.h"
#include "ast.h"
#include "dump_context.h"
#include "emit_asm.h"
#include "emit_basic.h"
#include "errors.h"
#include "lexer.h"
#include "lower.h"
#include "optimize.h"
#include "options.h"
#include "parser.h"
#include "preproc.h"
#include "semantic.h"
#include "symtab.h"
#include "utils.h"
#include "walker.h"
#include "zx81bas.h"
#include <cmath>
#include <cstdlib>
#include <filesystem>
#include <iomanip>
#include <iostream>
#include <memory>
#include <sstream>
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

[[noreturn]]
static void dump_tok_file_exit(const TokFile& tok_file) {
    if (get_error_count() == 0) {
        DumpContext ctx(std::cout);
        tok_file.dump(ctx);
    }
    exit_error_status();
}

[[noreturn]]
static void dump_prog_exit(const Prog& prog) {
    if (get_error_count() == 0) {
        DumpContext ctx(std::cout);
        prog.dump(ctx);
    }
    exit_error_status();
}

[[noreturn]]
static void dump_symtab_exit(const Symtab& symtab) {
    if (get_error_count() == 0) {
        DumpContext ctx(std::cout);
        symtab.dump(ctx);
    }
    exit_error_status();
}

[[noreturn]]
static void dump_basic_exit(const Prog& prog) {
    if (get_error_count() == 0) {
        for (const auto& line : prog.basic_lines) {
            std::cout << line.to_string();
        }
    }
    exit_error_status();
}

[[noreturn]]
static void dump_asm_source_exit(const std::vector<std::string>& asm_source) {
    if (get_error_count() == 0) {
        for (const auto& line : asm_source) {
            std::cout << line << std::endl;
        }
    }
    exit_error_status();
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
        dump_tok_file_exit(tok_file);
    }
#endif

    // parse the BASIC program
    std::unique_ptr<Prog> prog;
    if (!parse_basic(tok_file, prog)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 5) {
        dump_prog_exit(*prog);
    }
#endif

    // symbol table collection
    std::unique_ptr<Symtab> symtab;
    if (!create_symtab(*prog, symtab)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 6) {
        dump_symtab_exit(*symtab);
    }
#endif

    // semantic check
    if (!semantic_check(*prog)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 7) {
        dump_prog_exit(*prog);
    }
#endif

    // transform the program to lower-level constructs
    if (!semantic_transform(*prog, *symtab)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 8) {
        dump_prog_exit(*prog);
    }
#endif

    // lower to standard BASIC
    if (!lower_prog(*prog, *symtab)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 9) {
        dump_prog_exit(*prog);
    }
#endif

    // optimize basic
    if (!optimize(*prog)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 10) {
        dump_prog_exit(*prog);
    }
#endif

    // emit basic
    if (!emit_basic(*prog)) {
        exit_error_status();
    }

#ifdef _DEBUG
    if (g_dump_step == 11) {
        dump_basic_exit(*prog);
    }
#endif

    // pass 1: assemble and link to produce map file
    // pass 2: use map file to replace &labels with
    // addresses and produce final .p and .sym file
    // repeat until output stable
    int tail_addr = 0;
    for (int pass = 1; pass <= 2; ++pass) {
        // build assembly source
        std::vector<std::string> asm_source;
        if (!emit_asm(*prog, pass, asm_source)) {
            exit_error_status();
        }

#ifdef _DEBUG
        if (g_dump_step == 12 && pass == 1) {
            dump_asm_source_exit(asm_source);
        }
        if (g_dump_step == 13 && pass == 2) {
            dump_asm_source_exit(asm_source);
        }
#endif

        // call the assembler and linker to produce .P and .sym file
        if (!assemble_link(asm_source, input_basename, prog->label_addr)) {
            exit_error_status();
        }

        auto it = prog->label_addr.find("__tail");
        if (it != prog->label_addr.end()) {
            if (it->second != tail_addr) {
                // redo pass 1
                pass = 0;
                tail_addr = it->second;
            }
        }
    }

    // exit with error status
    exit_error_status();
}

// 10-digit precision to match 32-bit mantissa
std::string double_to_string(double value) {
    std::ostringstream oss;
    if (floor(value) == value) {
        oss << value;
    }
    else {
        oss << std::setprecision(10) << value;
    }
    return oss.str();
}
