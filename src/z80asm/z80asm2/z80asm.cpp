//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "cpu.h"
#include "error.h"
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

//-----------------------------------------------------------------------------
// Test
//-----------------------------------------------------------------------------

static void create_globals() {
    g_cpu_table = new CpuTable();
    g_location = new Location();
    g_error = new Error();
    g_input_files = new InputFiles();
    g_global_defines = new Symtab();
    g_preproc = new Preproc();
    g_obj_module = new ObjModule();
    g_options = new Options();
}

static void delete_globals() {
    delete g_options;
    g_options = nullptr;

    delete g_obj_module;
    g_obj_module = nullptr;

    delete g_preproc;
    g_preproc = nullptr;

    delete g_global_defines;
    g_global_defines = nullptr;

    delete g_input_files;
    g_input_files = nullptr;

    delete g_error;
    g_error = nullptr;

    delete g_location;
    g_location = nullptr;

    delete g_cpu_table;
    g_cpu_table = nullptr;
}

static int error_invalid_option(const string& option) {
    g_error->error_invalid_option(option);
    return EXIT_FAILURE;
}

static int help() {
    cout << "Usage: z80asm [options] [file...]" << endl
        << "Options:" << endl
        << "  -DNAME=EXPR Define a constant, EXPR is optional" << endl
        << "  -E          Preprocess only, do not assemble" << endl
        << "  -h          Show this help message" << endl
        << "  -mCPU       Select CPU, one of:" << endl
        << "              " << g_cpu_table->cpu_names(14, 72) << endl
        << "  -v          Verbose output" << endl
        << "  --          Stop processing options" << endl;
    return EXIT_SUCCESS;
}

int main(int argc, char* argv[]) {
#ifdef UNIT_TESTS
    Memmap::test();
    StringTable::test();
    return EXIT_SUCCESS;
#endif

    // Initialize global objects
    create_globals();
    atexit(delete_globals);

    // parse command line
    g_options->set_progname(argv[0]);
    argv++; argc--;

    bool found_dash_dash = false;
    while (!found_dash_dash && argc > 0 && argv[0][0] == '-') {
        string option = argv[0];
        switch (argv[0][1]) {
        case '-':
            if (option == "--")
                found_dash_dash = true;
            else
                return error_invalid_option(option);
            break;
        case 'D':
            if (option.size() > 2) {
                string line = option.substr(2);
                LineParser parser;
                if (!parser.parse_define(line))
                    return EXIT_FAILURE;
            }
            else
                return error_invalid_option(option);
            break;
        case 'E':
            if (option == "-E")
                g_options->set_preproc_only(true);
            else
                return error_invalid_option(option);
            break;
        case 'h':
            if (option == "-h")
                return help();
            else
                return error_invalid_option(option);
            break;
        case 'm':
            if (option.size() > 2) {
                string cpu_name = option.substr(2);
                const CpuInfo* info = g_cpu_table->get_info(cpu_name);
                if (!info) {
                    g_error->error_invalid_cpu(cpu_name);
                    cerr << "valid CPUs are: " << g_cpu_table->cpu_names() << endl;
                    return EXIT_FAILURE;
                }
                else {
                    g_options->set_cpu_id(info->id);
                }
            }
            else
                return error_invalid_option(option);
            break;
        case 'v':
            if (option == "-v")
                g_options->set_verbose(true);
            else
                return error_invalid_option(option);
            break;
        default:
            return error_invalid_option(option);
        }
        argv++; argc--;
    }

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

    if (g_options->preproc_only()) {
        for (auto& filename : g_options->input_files()) {
            g_preproc->preproc_only(filename);
        }
    }
    else {
        for (auto& filename : g_options->input_files()) {
            Assembler assembler;
            if (!assembler.assemble_file(filename))
                g_error->error_assembly_failed(filename);
        }
    }

    int exit_code = (g_error->count() == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
    return exit_code;
}
