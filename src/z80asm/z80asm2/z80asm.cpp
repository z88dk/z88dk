//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "error.h"
#include "input_files.h"
#include "line_parser.h"
#include "location.h"
#include "memmap.h"
#include "obj_module.h"
#include "options.h"
#include "preproc.h"
#include "symbol.h"
#include <iostream>
#include <string>
#include <cassert>
using namespace std;

//-----------------------------------------------------------------------------
// Test
//-----------------------------------------------------------------------------

static void create_globals() {
    g_location = new Location();
    g_error = new Error();
    g_input_files = new InputFiles();
    g_global_defines = new Symtab();
    g_preproc = new Preproc();
    g_obj_module = new ObjModule();
    g_options = new Options();
}

static void delete_globals() {
    delete g_location;
    g_location = nullptr;

    delete g_error;
    g_error = nullptr;

    delete g_input_files;
    g_input_files = nullptr;

    delete g_global_defines;
    g_global_defines = nullptr;

    delete g_preproc;
    g_preproc = nullptr;

    delete g_obj_module;
    g_obj_module = nullptr;

    delete g_options;
    g_options = nullptr;
}

static int error_unknown_option(const string& option) {
    cerr << "Unknown option: " << option << endl;
    return EXIT_FAILURE;
}

static int help() {
    cout << "Usage: z80asm [options] [file...]\n"
         << "Options:\n"
         << "  -E          Preprocess only, do not assemble\n"
         << "  -v          Verbose output\n"
         << "  --          Stop processing options\n";
    return EXIT_SUCCESS;
}

int main(int argc, char* argv[]) {
#ifdef _DEBUG
    Memmap::test();
    return EXIT_SUCCESS;
#endif

    create_globals();
    atexit(delete_globals);


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
                return error_unknown_option(option);
            break;
        case 'E':
            if (option == "-E")
                g_options->set_preproc_only(true);
            else
                return error_unknown_option(option);
            break;
        case 'h':
            if (option == "-h")
                return help();
            else
                return error_unknown_option(option);
            break;
        case 'v':
            if (option == "-v")
                g_options->set_verbose(true);
            else
                return error_unknown_option(option);
            break;
        default:
            return error_unknown_option(option);
        }
        argv++; argc--;
    }

    while (argc > 0) {
        g_options->add_input_file(argv[0]);
        argv++; argc--;
    }

    if (g_options->input_files().empty()) {
        cerr << "No input files specified." << endl;
        return EXIT_FAILURE;
    }

    if (g_options->preproc_only()) {
        for (auto& filename : g_options->input_files()) {
            g_preproc->preproc_only(filename);
        }
    }
    else {
        for (auto& filename : g_options->input_files()) {
            Assembler assembler;
            assembler.assemble_file(filename);
        }
    }

    int exit_code = g_error->count() ? EXIT_FAILURE : EXIT_SUCCESS;
    return exit_code;
}
