//-----------------------------------------------------------------------------
// z80asm - linker
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "linker.h"
#include "ofiles.h"
#include "symtab.h"
using namespace std;

Linker::Linker(const string& bin_filename)
    : bin_filename_(bin_filename) {
}

void Linker::link_library_modules() {
    int start_errors = g_errors.count();

    SearchedLibs libs;
    libs.read();                    // load lists of symbols defined in all libraries

    vector<Symbol*> unresolved;     // unresolved symbols
    while (true) {
        load_global_symbols();                      // load again, as resolve_symbol() has pulled another module
        if (start_errors != g_errors.count())
            return;

        link_extern_symbols(unresolved);            // link new externs to publics
        if (start_errors != g_errors.count())
            return;

        if (unresolved.empty())                     // finished maping all externs
            return;

        Symbol* symbol = unresolved.front();        // resolve in the order found
        if (!libs.resolve_symbol(symbol->name())) {
            g_errors.push_location(symbol->location());
            g_errors.error(ErrUndefinedSymbol, symbol->name());
            g_errors.pop_location();
        }

        if (start_errors != g_errors.count())
            return;
    }
}

void Linker::allocate_addresses() {
    // add sections to memory map
    for (MemoryArea* mem_area : g_asm.mem_map()) {     // for each area in the order created
        string name = mem_area->name();

        mem_area->clear_sections();                 // collect all sections with same name
        for (size_t i = 0; i < g_asm.objects().size(); i++) {
            g_asm.set_cur_object(i);                // for each object
            for (auto& module1 : g_asm.cur_object()) {  // for each module
                for (auto& section : *module1) {        // for each section
                    if (section->name() == name) {      // collect it into memory area
                        mem_area->add_section(section);
                    }
                }
            }
        }
    }

    // relocate addresses
    g_asm.mem_map().relocate_addresses();
}

void Linker::write()
{
}

void Linker::load_global_symbols() {
    int start_errors = g_errors.count();

    global_symbols_.clear();
    for (size_t i = 0; i < g_asm.objects().size(); i++) {
        g_asm.set_cur_object(i);
        for (auto& symbol : g_local_symbols()) {
            if (!symbol->is_alias() && symbol->scope() == SCOPE_PUBLIC) {
                Symbol* alias = new Symbol(symbol->name(), SCOPE_PUBLIC, symbol->type());
                global_symbols_.insert(alias);
                if (start_errors != g_errors.count())       // multiply defined
                    return;
                alias->set_alias(symbol);
            }
        }
    }
}

void Linker::link_extern_symbols(vector<Symbol*>& unresolved) {
    unresolved.clear();
    for (size_t i = 0; i < g_asm.objects().size(); i++) {
        g_asm.set_cur_object(i);
        for (auto& symbol : g_local_symbols()) {
            if (!symbol->is_alias() && symbol->scope() == SCOPE_EXTERN) {
                // check if already defined
                Symbol* defined = global_symbols_.find(symbol->name());
                if (defined)
                    symbol->set_alias(defined);         // make it point to public symbol
                else
                    unresolved.push_back(symbol);
            }
        }
    }
}
