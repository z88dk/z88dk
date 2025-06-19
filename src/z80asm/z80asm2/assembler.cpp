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

Assembler* g_assembler{ nullptr };

void Assembler::clear() {
    m_asm_filename.clear();
    m_obj_filename.clear();
    m_pass = Pass::NOT_ASSEMBLING;

    g_preproc->clear();
    g_obj_module->clear();
}

void Assembler::assemble_file(const string& filename) {
    init(filename);

    if (g_options->verbose())
        cout << "assemble " << m_asm_filename << " to " << m_obj_filename << endl;

    if (assemble()) {
        if (g_options->verbose())
            cout << "assembled " << m_asm_filename << " to " << m_obj_filename << endl;
    } else {
        g_error->error_assembly_failed(filename);
    }

    if (g_options->verbose())
        cout << endl;
}

void Assembler::init(const string& filename) {
    clear();
    m_asm_filename = filename;
    m_obj_filename = replace_extension(filename, ".o");
    g_input_files->push_file(filename);
}

bool Assembler::assemble() {
    // during pass 1, the addresses are not final
    m_pass = Pass::PASS1;
    g_obj_module->define_global_defs();
    g_obj_module->define_cpu_defs(g_options->cpu_id());
    if (!parse())
        return false;
    g_obj_module->expand_jrs();

    // set pass to 2 after addresses are final
    m_pass = Pass::PASS2;
    if (has_undefined_symbols())
        return false;
    resolve_local_exprs();
    if (!g_obj_module->write_file(m_obj_filename))
        return false;

    m_pass = Pass::NOT_ASSEMBLING;
    return true;
}

bool Assembler::parse() {
    bool ok = true;
    string line;
    while (g_input_files->getline(line)) {
        g_preproc->expand(line);
        string expanded_line;
        while (g_preproc->getline(expanded_line)) {
            LineParser parser;
            if (!parser.parse_line(expanded_line))
                ok = false;
        }
    }
    return ok;
}

bool Assembler::has_undefined_symbols() {
    return g_obj_module->has_undefined_symbols();
}

// resolve expressions that are local to the current module
void Assembler::resolve_local_exprs() {
    g_obj_module->resolve_local_exprs();
}
