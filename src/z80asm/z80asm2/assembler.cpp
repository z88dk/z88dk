//-----------------------------------------------------------------------------
// z80asm
// Assembler
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "error.h"
#include "input_files.h"
#include "line_parser.h"
#include "location.h"
#include "obj_module.h"
#include "preproc.h"
#include "utils.h"
using namespace std;

bool Assembler::assemble_file(const string& filename) {
    init(filename);

    if (!parse())
        return false;
    if (!resolve_jr())
        return false;
    if (!resolve_local_exprs())
        return false;
    if (!g_obj_module->write_file(m_filename))
        return false;

    return true;
}

void Assembler::init(const string& filename) {
    m_filename = filename;
    m_obj_filename = replace_extension(filename, ".o");

    g_preproc->clear();
    g_obj_module->clear();
    g_input_files->push_file(filename);
}

bool Assembler::parse() {
    bool ok = true;
    string line;
    while (g_input_files->getline(line)) {
        g_preproc->expand(line);
        string expanded_line;
        while (g_preproc->getline(expanded_line)) {
            g_location->set_expanded_text(expanded_line);
            LineParser parser;
            if (!parser.parse(expanded_line))
                ok = false;
        }
    }
    return ok;
}

// replace jr to distances too far with jp
bool Assembler::resolve_jr() {
    return false;
}

// resolve expressions that are local to the current module
bool Assembler::resolve_local_exprs() {
    return false;
}
