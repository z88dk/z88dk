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
    init(filename);
    define_global_defs();
    define_cpu_defs();

    bool ok = true;
    if (ok && !parse())
        ok = false;
    if (ok && !resolve_jr())
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

void Assembler::define_global_defs() {
    // copy global symbols to the symbol table
    for (const auto& it : *g_global_defines) {
        assert(it.second->sym_type() == SymType::GLOBAL_DEF
            && "Only GLOBAL_DEF expected");
        g_obj_module->add_define(it.first, it.second->value());
    }
}

void Assembler::define_cpu_defs() {
    // create symbols for the current CPU
    for (auto& define : g_cpu_table->all_defines())
        g_obj_module->remove_define(define);

    for (auto& define : g_cpu_table->cpu_defines(g_options->cpu_id()))
        g_obj_module->add_define(define, 1);
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
