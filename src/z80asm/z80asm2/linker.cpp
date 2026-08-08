//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "diag.h"
#include "files.h"
#include "linker.h"
#include "obj_file.h"
#include "obj_symbol_scope.h"
#include "release_assert.h"
#include "source_loc.h"
#include "strings.h"
#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

void Linker::add_input_modules(const std::vector<std::string>& filenames) {
    for (auto& filename : filenames) {
        std::string o_filename = get_o_filename(filename, output_dir_);
        auto obj_file = std::make_unique<ObjFile>(o_filename);
        input_modules_.push_back(std::move(obj_file));
    }
}

void Linker::add_input_libraries(const std::vector<std::string>& libraries) {
    for (auto& libname : libraries) {
        auto obj_file = std::make_unique<ObjFile>(libname);
        input_libraries_.push_back(std::move(obj_file));
    }
}

void Linker::set_output_dir(std::string_view output_dir) {
    output_dir_ = output_dir;
}

bool Linker::link() {
    // pull in modules from libraries until all symbols are resolved
    if (!resolve_symbols()) {
        return false; // error already reported
    }

    // make list of pulled modules in left-to-right order of appearance in input files
    pull_module_sequence();

#ifdef _DEBUG
    if (g_args.options.dump_after_link_collection) {
        std::cout << "Linker: Pulled modules in order of appearance:" << std::endl;
        for (auto& module : module_sequence_) {
            std::cout << "  " << module->module_name_string() << std::endl;
        }
        exit(EXIT_SUCCESS);
    }
#endif

    return true;
}

bool Linker::resolve_symbols() {
    // add all input modules
    for (auto& obj_file : input_modules_) {
        for (size_t i = 0; i < obj_file->num_modules(); ++i) {
            ObjModule* module = obj_file->module(i);
            if (!add_module(module)) {
                return false;
            }
        }
    }

    // scan input libraries for undefined symbols
    bool progress = true;
    while (progress && !undefined_symbols_.empty()) {
        progress = false;
        for (auto& [sym_name_id, _] : undefined_symbols_) {
            for (auto& obj_file : input_libraries_) {
                ObjModule* module = obj_file->lookup_public_symbol(sym_name_id);
                if (module) {
                    if (!add_module(module)) {
                        return false;
                    }
                    progress = true;
                    break; // break library loop
                }
            }
            if (progress) {
                break;    // break symbol loop -> restart outer while
            }
        }
    }

    if (undefined_symbols_.empty()) {
        return true; // all symbols resolved
    }
    else {
        g_diag.error(SourceLoc(), "Unresolved symbols");

        // collect symbols and sort alphabetically
        std::vector<std::pair<StringId, ObjModule*>> sorted_symbols(
                    undefined_symbols_.begin(), undefined_symbols_.end());
        std::sort(sorted_symbols.begin(), sorted_symbols.end(),
        [](const auto & a, const auto & b) {
            return g_strings.view(a.first) < g_strings.view(b.first);
        });

        for (auto& [sym, module] : sorted_symbols) {
            g_diag.note(SourceLoc(), "Symbol " + std::string(g_strings.view(sym)) +
                        " referenced by " + module->module_name_string());
        }
        return false; // unresolved symbols remain
    }
}

bool Linker::add_module(ObjModule* module) {
    // check if CPU and swap_ixiy are compatible with the current settings
    if (!!g_args.options.swap_ixiy != !!module->swap_ixiy() ) {
        g_diag.error(SourceLoc(),
                     "Incompatible -IXIY setting for " + module->module_name_string());
        g_diag.note(SourceLoc(),
                    "Current -IXIY setting: " + std::string(g_args.options.swap_ixiy ? "true" :
                            "false"));
        g_diag.note(SourceLoc(),
                    "Module -IXIY setting:  " + std::string(module->swap_ixiy() ? "true" :
                            "false"));
        return false;
    }

    if (!cpu_compatible(g_args.options.cpu_id, module->cpu_id())) {
        g_diag.error(SourceLoc(),
                     "Incompatible CPU setting for " + module->module_name_string());
        g_diag.note(SourceLoc(),
                    "Current CPU setting: " + to_string(g_args.options.cpu_id));
        g_diag.note(SourceLoc(), "Module CPU setting:  " + to_string(module->cpu_id()));
        return false;
    }

    // add module to link set
    selected_modules_.insert(module);

    // add new public symbols
    for (auto& sym : *module->symbols()) {
        if (sym.scope == ObjSymbolScope::Public) {
            auto it = defined_symbols_.find(sym.symbol_name_id);
            if (it == defined_symbols_.end()) {
                defined_symbols_[sym.symbol_name_id] = module;
            }
            else {
                g_diag.error(SourceLoc(),
                             "Duplicate definition: " + std::string(sym.symbol_name()));
                g_diag.note(SourceLoc(),
                            "First definition:  " + it->second->module_name_string());
                g_diag.note(SourceLoc(),
                            "Second definition: " + module->module_name_string());
            }
        }
    }

    // add new undefined symbols
    for (auto& sym : *module->externs()) {
        auto it = defined_symbols_.find(sym.symbol_name_id);
        if (it == defined_symbols_.end()) {
            undefined_symbols_[sym.symbol_name_id] = module;
        }
    }

    // remove any undefined symbols that are now defined
    for (auto it = undefined_symbols_.begin(); it != undefined_symbols_.end(); ) {
        auto defined_it = defined_symbols_.find(it->first);
        if (defined_it != defined_symbols_.end()) {
            it = undefined_symbols_.erase(it);
        }
        else {
            ++it;
        }
    }

    return true;
}

void Linker::pull_module_sequence() {
    // pull input modules in order of appearance
    for (auto& obj_file : input_modules_) {
        for (size_t i = 0; i < obj_file->num_modules(); ++i) {
            ObjModule* module = obj_file->module(i);
            if (selected_modules_.count(module) > 0) {
                module_sequence_.push_back(module);
                selected_modules_.erase(module);
            }
        }
    }

    // pull library modules in order of appearance
    if (!selected_modules_.empty()) {
        for (auto& obj_file : input_libraries_) {
            for (size_t i = 0; i < obj_file->num_modules(); ++i) {
                ObjModule* module = obj_file->module(i);
                if (selected_modules_.count(module) > 0) {
                    module_sequence_.push_back(module);
                    selected_modules_.erase(module);

                    if (selected_modules_.empty()) {
                        return; // all modules pulled
                    }
                }
            }
        }
    }

    // we cannot have more modules selected at this point,
    // because they should have been pulled from the libraries
    release_assert(selected_modules_.empty());
}

bool link_files(const std::vector<std::string>& objects,
                const std::vector<std::string>& libraries,
                std::string_view output_dir) {
    Linker linker;
    linker.add_input_modules(objects);
    linker.add_input_libraries(libraries);
    linker.set_output_dir(output_dir);

    return linker.link();
}

