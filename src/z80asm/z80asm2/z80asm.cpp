//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "input_files.h"
#include "line_parser.h"
#include "location.h"
#include "obj_module.h"
#include "preproc.h"
#include "symbol.h"
#include <iostream>
#include <string>
using namespace std;

//-----------------------------------------------------------------------------
// Test
//-----------------------------------------------------------------------------

void parse_file(const string& filename) {
    g_preproc->clear();
    g_obj_module->clear();

    g_input_files->push_file(filename);
	string line;
	while (g_input_files->getline(line)) {
		g_preproc->expand(line);
		string expanded_line;
		while (g_preproc->getline(expanded_line)) {
			g_location->set_expanded_text(expanded_line);
			cout << g_location->filename() << ":" << g_location->line_num() << ": " << line << endl << expanded_line << endl;
            LineParser parser;
            if (!parser.parse(expanded_line))
                cout << "parse failed" << endl;
		}
	}
}

void create_globals() {
    g_location = new Location();
    g_error = new Error();
    g_input_files = new InputFiles();
    g_global_defines = new Symtab();
    g_preproc = new Preproc();
    g_obj_module = new ObjModule();
}

void delete_globals() {
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
}

int main(int argc, char* argv[]) {
    create_globals();
	for (int i = 1; i < argc; i++) {
		parse_file(argv[i]);
	}

    int exit_code = g_error->count() ? EXIT_FAILURE : EXIT_SUCCESS;
    delete_globals();
    return exit_code;
}
