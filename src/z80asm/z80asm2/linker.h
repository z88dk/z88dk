//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "module.h"
#include <memory>
#include <set>
#include <string>
#include <unordered_map>
#include <vector>

//-----------------------------------------------------------------------------
// Linker - manages the linking process
//-----------------------------------------------------------------------------
class Linker {
public:
    Linker();

    // Add a module to the linked program
    // Extracts public symbols and updates unresolved extern list
    // Returns pointer to added module
    Module* add_module(std::unique_ptr<Module> module);

    // Add a library to the search path
    void add_library(Library* library);

    // Link against libraries to resolve remaining extern symbols
    // Pulls in modules from libraries as needed
    // Returns true if all symbols resolved, false if unresolved symbols remain
    bool link_libraries();

    // Get list of modules in link order
    const std::vector<std::unique_ptr<Module>>& modules() const;

    // Get public symbol map (symbol name -> defining module)
    const std::unordered_map<std::string, Module*>& public_symbols() const;

    // Get list of unresolved extern symbols
    const std::unordered_map<std::string, std::vector<Location>>&
            unresolved_externs() const;

    // Check if there are unresolved symbols
    bool has_unresolved_symbols() const;

    // Get library search path
    const std::vector<Library*>& libraries() const;

    // Clear all state
    void clear();

    // Statistics
    size_t module_count() const;
    size_t public_symbol_count() const;
    size_t unresolved_symbol_count() const;

private:
    // Update public symbols from a module
    void index_module_public_symbols(Module* module);

    // Update unresolved externs after adding a module
    void update_unresolved_externs(Module* module);

    // Try to resolve a symbol from libraries
    // Returns the module that defines the symbol, or nullptr if not found
    Module* resolve_from_libraries(const std::string& symbol_name);

    std::vector<std::unique_ptr<Module>>
                                      modules_;                          // Modules in link order
    std::vector<Library*>
    libraries_;                                       // Library search path (non-owning)
    std::unordered_map<std::string, Module*>
    public_symbols_;              // Public symbol -> defining module
    std::unordered_map<std::string, std::vector<Location>>
            unresolved_externs_;  // Unresolved symbol -> locations where referenced
    std::set<Module*> library_modules_pulled_;
    std::set<std::string>
    currently_resolving_; // Track symbols being resolved to detect cycles

    // Helper to resolve with cycle detection
    Module* resolve_with_cycle_detection(const std::string& symbol_name,
                                         int depth = 0);
    static constexpr int MAX_RESOLUTION_DEPTH = 100; // Prevent infinite recursion
};

