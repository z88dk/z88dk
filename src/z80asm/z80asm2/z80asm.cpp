//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "cpu.h"
#include "error.h"
#include "expr.h"
#include "input_files.h"
#include "line_parser.h"
#include "location.h"
#include "memmap.h"
#include "obj_module.h"
#include "options.h"
#include "preproc.h"
#include "string_table.h"
#include "symbol.h"
#include <cassert>
#include <iostream>
#include <string>
using namespace std;

// environment valiable that contains options to be passed on every invocation
static const string Z80ASM_ENV = "Z80ASM";

static void create_globals() {
    g_cpu_table = new CpuTable();
    g_arch_table = new ArchTable();
    g_location = new Location();
    g_source_text = new SourceText();
    g_error = new Error();
    g_input_files = new InputFiles();
    g_options = new Options();
    g_global_defines = new Symtab();
    g_preproc = new Preproc();
    g_obj_module = new ObjModule();
    g_assembler = new Assembler();
}

static void delete_globals() {
    delete g_assembler; g_assembler = nullptr;
    delete g_obj_module; g_obj_module = nullptr;
    delete g_preproc; g_preproc = nullptr;
    delete g_global_defines; g_global_defines = nullptr;
    delete g_options; g_options = nullptr;
    delete g_input_files; g_input_files = nullptr;
    delete g_error; g_error = nullptr;
    delete g_source_text; g_source_text = nullptr;
    delete g_location; g_location = nullptr;
    delete g_arch_table; g_arch_table = nullptr;
    delete g_cpu_table; g_cpu_table = nullptr;
}

static int help() {
    cout << "Usage: z80asm [options] [file...]" << endl
        << "Options:" << endl
        << "  +ARCH       Select architecture, one of:" << endl
        << "              " << g_arch_table->arch_names(14, 72) << endl
        << "  -D[=]SYMBOL[=VALUE]" << endl
        << "              Define a static symbol in decimal or hex" << endl
        << "  -E          Preprocess only, do not assemble" << endl
        << "  -fBYTE      Default value to fill in DEFS in decimal or hex" << endl
        << "  -h          Show this help message" << endl
		<< "  -IXIY       Swap IX and IY registers" << endl
		<< "  -IXIY-soft  Swap IX and IY registers but write object as unswapped" << endl
        << "  -mCPU       Select CPU, one of:" << endl
        << "              " << g_cpu_table->cpu_names(14, 72) << endl
        << "  -rADDR      Relocate binary file to given address in decimal or hex" << endl
        << "  -v          Verbose output" << endl
        << "  --          Stop processing options" << endl;
    return EXIT_SUCCESS;
}

static void check_verbose_option(const string& option) {
    if (option == "-v")
        g_options->set_verbose(true);
}

static bool parse_option(const string& option) {
    if (option.size() < 2)
        return false;
    else if (option[0] == '+') {
        string arch_name = option.substr(1);
        const ArchInfo* info = g_arch_table->get_info(arch_name);
        if (!info) {
            g_error->error_invalid_arch(arch_name);
            cerr << "valid architectures are: " << g_arch_table->arch_names() << endl;
            exit(EXIT_FAILURE);
            return false; // not reached
        }
        else {
            g_options->set_cpu_id(info->cpu_id);
            g_options->set_arch(info->id);
            return true;
        }
    }
    else if (option[0] != '-')
        return false;
    else {
        switch (option[1]) {
        case 'D':
            if (option.size() > 2) {
                string line = "define " + option.substr(2);
                LineParser parser;
                if (!parser.parse_line(line))
                    return false;
            }
            else
                return false;
            break;
        case 'E':
            if (option == "-E")
                g_options->set_preproc_only(true);
            else
                return false;
            break;
        case 'f':
            if (option.size() > 2) {
                string filler_str = option.substr(2);
                Expr expr;
                int filler = 0;
                if (!expr.parse(filler_str))
                    return false;
                if (!expr.eval_const(filler))
                    return false;
                if (filler < 0 || filler > 0xFF) {
                    g_error->error_int_range(int_to_hex(filler, 2));
                    return false;
                }
                g_options->set_filler(filler);
            }
            else
                return false;
            break;
        case 'h':
            if (option == "-h") {
                exit(help());
                return true; // not reached
            }
            else
                return false;
            break;
        case 'I':
            if (option == "-IXIY")
                g_options->set_swap_ixiy(SwapIXIY::SWAP);
            else if (option == "-IXIY-soft")
                g_options->set_swap_ixiy(SwapIXIY::SOFT_SWAP);
            else
                return false;
            break;
        case 'm':
            if (option.size() > 2) {
                string cpu_name = option.substr(2);
                const CpuInfo* info = g_cpu_table->get_info(cpu_name);
                if (!info) {
                    g_error->error_invalid_cpu(cpu_name);
                    cerr << "valid CPUs are: " << g_cpu_table->cpu_names() << endl;
                    exit(EXIT_FAILURE);
                    return false; // not reached
                }
                else {
                    g_options->set_cpu_id(info->id);
                }
            }
            else
                return false;
            break;
        case 'r':
            if (option.size() > 2) {
                string origin_str = option.substr(2);
                int origin = 0;
                Expr expr;
                if (!expr.parse(origin_str) || !expr.eval_const(origin)) {
                    return false;
                }
                else {
                    g_options->set_origin(origin);
                }
            }
            else
                return false;
            break;
        case 'v':
            if (option == "-v")
                g_options->set_verbose(true);
            else
                return false;
            break;
        default:
            return false;
        }
        return true;
    }
}

int main(int argc, char* argv[]) {
    // Initialize global objects
    create_globals();
    atexit(delete_globals);

#ifdef UNIT_TESTS
    Memmap::test();
    StringTable::test();
    Expr::test();
    Scanner::test();
    return EXIT_SUCCESS;
#endif

    // parse command line
    g_options->set_parsing_command_line(true);
    g_options->set_progname(remove_extension(basename(argv[0])));

    // check for verbose option
    string z80asm_env_value = get_envvar(Z80ASM_ENV);
    for (auto& option : split_by_whitespace(z80asm_env_value))
        check_verbose_option(option);
    for (int i = 1; i < argc; i++)
        check_verbose_option(argv[i]);

    // show command line if verbose
    if (g_options->verbose()) {
        if (!z80asm_env_value.empty())
            cout << Z80ASM_ENV << "=" << z80asm_env_value << endl;
        cout << "% " << g_options->progname();
        for (int i = 1; i < argc; i++)
            cout << " " << argv[i];
        cout << endl;
    }

    // parse options
    bool found_dash_dash = false;
    argv++; argc--;
    while (!found_dash_dash && argc > 0 &&
        (argv[0][0] == '-' || argv[0][0] == '+')) {
        string option = argv[0];
        if (option == "--")
            found_dash_dash = true;
        else if (!parse_option(option)) {
            g_error->error_invalid_option(option);
            return EXIT_FAILURE;
        }
        argv++; argc--;
    }

    // parse files
    while (argc > 0) {
        g_options->add_input_file(argv[0]);
        argv++; argc--;
    }

    if (g_options->input_files().empty()) {
        g_error->error_no_input_files();
        return EXIT_FAILURE;
    }

    if (g_error->count())
        return EXIT_FAILURE;

    // execute required options
    g_options->set_parsing_command_line(false);

    if (g_options->preproc_only()) {
        for (auto& filename : g_options->input_files()) {
            g_preproc->preproc_only(filename);
        }
    }
    else {
        for (auto& filename : g_options->input_files()) {
            g_assembler->assemble_file(filename);                
        }
    }

    int exit_code = (g_error->count() == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
    return exit_code;
}
