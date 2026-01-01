//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "library.h"
#include "module.h"

//-----------------------------------------------------------------------------
// Library implementation
//-----------------------------------------------------------------------------

Library::Library(const std::string& filename)
    : filename_(filename) {
}

const std::string& Library::filename() const {
    return filename_;
}

const std::unordered_map<std::string, Module*>& Library::public_symbols()
const {
    return public_symbols_;
}

Module* Library::find_public_symbol(const std::string& name) {
    auto it = public_symbols_.find(name);
    if (it != public_symbols_.end()) {
        return it->second;
    }
    return nullptr;
}

const Module* Library::find_public_symbol(const std::string& name) const {
    auto it = public_symbols_.find(name);
    if (it != public_symbols_.end()) {
        return it->second;
    }
    return nullptr;
}

bool Library::has_public_symbol(const std::string& name) const {
    return public_symbols_.find(name) != public_symbols_.end();
}

const std::vector<std::unique_ptr<Module>>& Library::modules() const {
    return modules_;
}

Module* Library::add_module(std::unique_ptr<Module> module) {
    if (!module) {
        return nullptr;
    }

    Module* module_ptr = module.get();
    modules_.push_back(std::move(module));

    // Index all public symbols from this module
    index_module_public_symbols(module_ptr);

    return module_ptr;
}

Module* Library::find_module(const std::string& name) {
    for (auto& module : modules_) {
        if (module->name() == name) {
            return module.get();
        }
    }
    return nullptr;
}

const Module* Library::find_module(const std::string& name) const {
    for (auto& module : modules_) {
        if (module->name() == name) {
            return module.get();
        }
    }
    return nullptr;
}

void Library::clear_modules() {
    modules_.clear();
    public_symbols_.clear();
}

void Library::rebuild_public_symbol_index() {
    public_symbols_.clear();

    // Rebuild index from all modules
    for (auto& module : modules_) {
        index_module_public_symbols(module.get());
    }
}

void Library::index_module_public_symbols(Module* module) {
    if (!module) {
        return;
    }

    // Index all public symbols from this module
    for (const auto& [name, symbol] : module->symbols()) {
        if (symbol.is_public()) {
            // If symbol already exists, keep first occurrence (library order matters)
            if (public_symbols_.find(name) == public_symbols_.end()) {
                public_symbols_[name] = module;
            }
        }
    }
}

size_t Library::module_count() const {
    return modules_.size();
}

size_t Library::public_symbol_count() const {
    return public_symbols_.size();
}

