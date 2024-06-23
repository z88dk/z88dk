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

Linker::~Linker() {
    for (auto& area : areas_)
        delete area;
}

void Linker::link() {
    int start_errors = g_errors.count();

    // link externs to globals
    link_symbols();
    if (start_errors != g_errors.count())
        return;

    // pull in libraries, unless building a consol_obj_file 
    if (!g_options.is_consol_obj()) {
        link_library_modules();
        if (start_errors != g_errors.count())
            return;
    }

    // concatenate sections of all loaded modules
    concatenate_sections();
    if (start_errors != g_errors.count())
        return;

    allocate_addresses();
    if (start_errors != g_errors.count())
        return;

}

void Linker::write() {
}

void Linker::link_symbols() {
    int start_errors = g_errors.count();

    global_symbols_.clear();
    unresolved_.clear();

    // load global symbols
    load_global_symbols();
    if (start_errors != g_errors.count())
        return;

    // link externs to publics
    link_extern_symbols();
    if (start_errors != g_errors.count())
        return;
}

void Linker::link_extern_symbols() {
    for (size_t i = 0; i < g_asm.objects().size(); i++) {
        g_asm.set_cur_object(i);
        for (auto& symbol : g_local_symbols()) {
            if (symbol->scope() == SCOPE_EXTERN) {
                // check if already defined
                Symbol* defined = global_symbols_.find(symbol->name());
                if (defined)
                    symbol->set_alias(defined);         // make it point to public symbol
                else
                    unresolved_.push_back(symbol);
            }
        }
    }
}

void Linker::link_library_modules() {
    int start_errors = g_errors.count();

    SearchedLibs libs;
    libs.read();                    // load lists of symbols defined in all libraries

    while (true) {
        link_symbols();             // link again, as resolve_symbol() has pulled another module
        if (unresolved_.empty())    // finished maping all externs
            return;

        // resolve symbols in the order found
        Symbol* symbol = unresolved_.front();
        if (!libs.resolve_symbol(symbol->name())) {
            g_errors.push_location(symbol->location());
            g_errors.error(ErrUndefinedSymbol, symbol->name());
            g_errors.pop_location();
        }

        if (start_errors != g_errors.count())
            return;
    }
}

Linker::SectionParams Linker::get_section_params(const string& section_name) {
    SectionParams params;

    // get bin_filename
    if (section_name.empty())
        params.bin_filename = bin_filename_;
    else {
        params.bin_filename = file_replace_extension(params.bin_filename, "");
        params.bin_filename += string("_") + section_name + EXT_BIN;
    }

    bool first_section = true;
    for (size_t i = 0; i < g_asm.objects().size(); i++) {   // for each object
        g_asm.set_cur_object(i);
        for (auto& module1 : g_asm.cur_object()) {          // for each module
            for (auto& section : *module1) {                // for each section
                g_errors.push_location(Location(module1->name()));

                if (section->name() == section_name) {      // same name

                    // get origin
                    if (g_options.relocatable() && section->origin() != ORG_NOT_DEFINED) {
                        g_errors.warning(ErrOrgIgnored, section->origin());
                    }
                    else if (g_options.appmake() && section->origin() != ORG_NOT_DEFINED &&
                        !first_section) {
                        g_errors.warning(ErrOrgIgnored, section->origin());
                    }
                    else if (params.origin == ORG_NOT_DEFINED) {
                        params.origin = section->origin();
                    }
                    else if (section->origin() != ORG_NOT_DEFINED &&
                        section->origin() != params.origin) {
                        g_errors.warning(ErrOrgRedefined, section->origin());
                    }

                    // get align
                    if (params.align == 1) {
                        params.align = section->align();
                    }
                    else if (section->align() != 1 &&
                        section->align() != params.align) {
                        g_errors.warning(ErrAlignRedefined, section->align());
                    }

                    // get split
                    if (params.split == false) {
                        params.split = section->section_split();
                    }

                    // get size
                    params.size += section->size();

                    first_section = false;
                }

                g_errors.pop_location();
            }
        }
    }

    return params;
}

void Linker::concatenate_sections() {
    areas_.clear();
    areas_.push_back(new MemoryArea);
    areas_.back()->bin_filename = bin_filename_;
    int address = 0;

    for (auto& section_name : g_asm.section_names().names()) {  // for each named section
        SectionParams params = get_section_params(section_name);

        for (size_t i = 0; i < g_asm.objects().size(); i++) {   // for each object
            g_asm.set_cur_object(i);
            for (auto& module1 : g_asm.cur_object()) {          // for each module
                for (auto& section : *module1) {                // for each section
                    if (section->name() == section_name) {      // same name
                        // check if need to create another memory area
                        bool need_break = false;
                        if (areas_.back()->size == 0)           // first section
                            need_break = false;
                        else if (g_options.is_consol_obj())     // consolidated object
                            need_break = false;
                        else if (params.origin != ORG_NOT_DEFINED) // origin change
                            need_break = true;
                        else if (params.split)                  // section split
                            need_break = true;

                        else if (section->origin() != ORG_NOT_DEFINED)  // no org defined

                    }
                }
            }
        }
    }
}

void Linker::allocate_addresses() {
    // add sections to memory map
    for (SectionArea* area : g_asm.section_areas()) {   // for each area in the order created
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

void Linker::load_global_symbols() {
    int start_errors = g_errors.count();

    for (size_t i = 0; i < g_asm.objects().size(); i++) {
        g_asm.set_cur_object(i);
        for (auto& symbol : g_local_symbols()) {
            if (symbol->scope() == SCOPE_PUBLIC) {
                Symbol* alias = new Symbol(symbol->name(), SCOPE_PUBLIC, symbol->type());
                global_symbols_.insert(alias);
                if (start_errors != g_errors.count())       // multiply defined
                    return;
                alias->set_alias(symbol);
            }
        }
    }
}

