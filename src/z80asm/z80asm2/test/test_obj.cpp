//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _DEBUG

#include "../dump_context.h"
#include "../obj_file.h"
#include "../strings.h"
#include <iostream>
#include <string>
#include <string_view>
#include <vector>

void test_obj_wb_show_obj_file(const std::vector<std::string>& args) {
    if (args.size() != 1) {
        std::cerr << "Usage: test_obj_wb_show_obj_file <obj_file>" << std::endl;
        return;
    }

    DumpContext ctx(std::cout);
    ObjFile obj_file(args[0]);
    ctx.line("Dumping object file: " + args[0]);
    obj_file.dump_loaded_sections(ctx.child());
    auto c = ctx.child();
    c.line("Number of modules: " + std::to_string(obj_file.num_modules()));
    c.line("Object file type: " + std::string(obj_file.type() == ObjFileType::Object
            ? "Object" : "Library"));
    c.line("Object file version: " + std::to_string(obj_file.version()));
    c.line("Included modules:");
    for (size_t i = 0; i < obj_file.num_modules(); ++i) {
        ObjModule* module = obj_file.module(i);
        if (module) {
            c.child().line("Module " + std::to_string(i) + ": " + std::string(
                               module->modname()->name()));
        }
    }
    for (std::string_view sym_name : {
                "public1", "public2", "nonexistent"
            }) {
        StringId sym_id = g_strings.intern(sym_name);
        ObjModule* module = obj_file.lookup_public_symbol(sym_id);
        if (module) {
            c.line("Found module for public symbol '" + std::string(sym_name) + "': " +
                   std::string(module->modname()->name()));
        }
        else {
            c.line("Public symbol '" + std::string(sym_name) +
                   "' not found in any module.");
        }
    }
    obj_file.dump(c);
    obj_file.dump_loaded_sections(c);
}

void test_obj_wb_lookup_symbols(const std::vector<std::string>& args) {
    if (args.size() != 1) {
        std::cerr << "Usage: test_obj_wb_lookup_symbols <obj_file>" << std::endl;
        return;
    }

    DumpContext ctx(std::cout);
    ObjFile obj_file(args[0]);
    ctx.line("Dumping object file: " + args[0]);
    auto c = ctx.child();
    for (int m = 0; m <= 255; m++) {
        for (int s = 0; s <= 255; s++) {
            std::string sym_name = "public" + std::to_string(m) + "_" + std::to_string(s);
            StringId sym_id = g_strings.intern(sym_name);
            ObjModule* module = obj_file.lookup_public_symbol(sym_id);
            if (module) {
                c.line("Found module for public symbol '" +
                       std::string(g_strings.view(sym_id)) + "': " +
                       std::string(module->modname()->name()));
            }
        }
    }
}

#endif
