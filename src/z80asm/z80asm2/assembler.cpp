//-----------------------------------------------------------------------------
// z80asm
// Assembler
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "cpu.h"
#include "error.h"
#include "input_files.h"
#include "line_parser.h"
#include "location.h"
#include "obj_module.h"
#include "options.h"
#include "preproc.h"
#include "utils.h"
#include <cassert>
using namespace std;

bool Assembler::assemble_file(const string& filename) {
    bool ok = true;

    init(filename);
    g_obj_module->define_global_defs();
    g_obj_module->define_cpu_defs(g_options->cpu_id());

    if (ok && !parse())
        ok = false;

    if (ok)
        g_obj_module->expand_jrs();

    if (ok && has_undefined_symbols())
        ok = false;

    if (ok && !resolve_local_exprs())
        ok = false;

    if (ok && !g_obj_module->write_file(m_filename))
        ok = false;

    if (g_options->verbose() && ok)
        cout << "assembled " << m_filename << " to " << m_obj_filename << endl;

    if (g_options->verbose())
        cout << endl;

    return ok;
}

void Assembler::init(const string& filename) {
    m_filename = filename;
    m_obj_filename = replace_extension(filename, ".o");

    if (g_options->verbose())
        cout << "assemble " << m_filename << " to " << m_obj_filename << endl;

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
            if (!parser.parse_line(expanded_line))
                ok = false;
        }
    }
    return ok;
}

bool Assembler::has_undefined_symbols() {
    return true;
}

// resolve expressions that are local to the current module
bool Assembler::resolve_local_exprs() {
    return false;
}
