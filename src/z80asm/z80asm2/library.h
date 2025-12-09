//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "module.h"
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

//-----------------------------------------------------------------------------
// Library - represents a library file (.lib) used during linking
//-----------------------------------------------------------------------------
class Library {
public:
    // Constructor requires library filename
    explicit Library(const std::string& filename);

    // Library identification
    const std::string& filename() const;

    // Public symbol index - maps symbol names to modules that define them
    // This allows quick lookup during symbol resolution without scanning all modules
    const std::unordered_map<std::string, Module*>& public_symbols() const;

    // Find which module defines a public symbol
    // Returns nullptr if symbol not found or not public
    Module* find_public_symbol(const std::string& name);
    const Module* find_public_symbol(const std::string& name) const;

    // Check if library exports a symbol
    bool has_public_symbol(const std::string& name) const;

    // Module management
    const std::vector<std::unique_ptr<Module>>& modules() const;

    // Add module to library
    // Automatically indexes public symbols from the module
    Module* add_module(std::unique_ptr<Module> module);

    // Find module by name
    Module* find_module(const std::string& name);
    const Module* find_module(const std::string& name) const;

    // Clear all modules (also clears public symbol index)
    void clear_modules();

    // Rebuild public symbol index from all modules
    // Called automatically by add_module(), but can be called manually
    // if symbol scopes change after modules are added
    void rebuild_public_symbol_index();

    // Statistics
    size_t module_count() const;
    size_t public_symbol_count() const;

private:
    // Index public symbols from a single module
    // Used by add_module() and rebuild_public_symbol_index()
    void index_module_public_symbols(Module* module);

    std::string filename_;                                      // Library filename
    std::vector<std::unique_ptr<Module>>
                                      modules_;             // All modules in this library
    std::unordered_map<std::string, Module*>
    public_symbols_;  // Public symbol name -> defining module
};

