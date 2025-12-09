//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "library.h"
#include "linker.h"

//-----------------------------------------------------------------------------
// Linker implementation
//-----------------------------------------------------------------------------

Linker::Linker() {
}

Module* Linker::add_module(std::unique_ptr<Module> module) {
    if (!module) {
        return nullptr;
    }

    Module* module_ptr = module.get();
    modules_.push_back(std::move(module));

    // Index public symbols from this module
    index_module_public_symbols(module_ptr);

    // Update unresolved externs list
    update_unresolved_externs(module_ptr);

    return module_ptr;
}

void Linker::add_library(Library* library) {
    if (library) {
        libraries_.push_back(library);
    }
}

bool Linker::link_libraries() {
    // Keep trying to resolve symbols until no more progress
    bool progress = true;
    int iteration = 0;
    const int MAX_ITERATIONS = 1000; // Prevent infinite loops

    while (progress && !unresolved_externs_.empty() && iteration < MAX_ITERATIONS) {
        progress = false;
        iteration++;

        // Take a copy of unresolved symbols (map may be modified during iteration)
        std::vector<std::string> symbols_to_resolve;
        for (const auto& [symbol_name, locations] : unresolved_externs_) {
            symbols_to_resolve.push_back(symbol_name);
        }

        // Try to resolve each symbol
        for (const auto& symbol_name : symbols_to_resolve) {
            // Skip if already resolved in a previous iteration
            if (unresolved_externs_.find(symbol_name) == unresolved_externs_.end()) {
                continue;
            }

            Module* defining_module = resolve_from_libraries(symbol_name);
            if (defining_module) {
                progress = true;
                // Symbol is now resolved (removed by resolve_from_libraries updating public_symbols_)
                unresolved_externs_.erase(symbol_name);
            }
        }
    }

    if (iteration >= MAX_ITERATIONS) {
        g_errors.error(Location(), ErrorCode::LinkError,
                       "Maximum link iterations exceeded - possible circular dependencies");
    }

    // Report any remaining unresolved symbols
    for (const auto& [symbol_name, locations] : unresolved_externs_) {
        for (const auto& loc : locations) {
            g_errors.error(loc, ErrorCode::UndefinedSymbol,
                           "Unresolved external symbol: " + symbol_name);
        }
    }

    return unresolved_externs_.empty();
}

const std::vector<std::unique_ptr<Module>>& Linker::modules() const {
    return modules_;
}

const std::unordered_map<std::string, Module*>& Linker::public_symbols() const {
    return public_symbols_;
}

const std::unordered_map<std::string, std::vector<Location>>&
        Linker::unresolved_externs()
const {
    return unresolved_externs_;
}

bool Linker::has_unresolved_symbols() const {
    return !unresolved_externs_.empty();
}

const std::vector<Library*>& Linker::libraries() const {
    return libraries_;
}

void Linker::clear() {
    modules_.clear();
    libraries_.clear();
    public_symbols_.clear();
    unresolved_externs_.clear();
    library_modules_pulled_.clear();
    currently_resolving_.clear();
}

size_t Linker::module_count() const {
    return modules_.size();
}

size_t Linker::public_symbol_count() const {
    return public_symbols_.size();
}

size_t Linker::unresolved_symbol_count() const {
    return unresolved_externs_.size();
}

void Linker::index_module_public_symbols(Module* module) {
    if (!module) {
        return;
    }

    // Index all public symbols from this module
    for (const auto& [name, symbol] : module->symbols()) {
        if (symbol.is_public()) {
            // Check for duplicate public symbols
            auto it = public_symbols_.find(name);
            if (it != public_symbols_.end()) {
                g_errors.error(symbol.location(), ErrorCode::SymbolRedefined,
                               "Duplicate public symbol: " + name +
                               " (first defined in module " + it->second->name() + ")");
            }
            else {
                public_symbols_[name] = module;
            }
        }
    }
}

void Linker::update_unresolved_externs(Module* module) {
    if (!module) {
        return;
    }

    // Process extern symbols from this module
    for (const auto& [name, symbol] : module->symbols()) {
        if (symbol.is_extern()) {
            // Check if this symbol is now defined by a public symbol
            if (public_symbols_.find(name) != public_symbols_.end()) {
                // Symbol is resolved - remove from unresolved list if present
                unresolved_externs_.erase(name);
            }
            else {
                // Symbol is still unresolved
                // Add all declaration locations from this module
                const auto& decl_locs = module->get_extern_declarations(name);
                for (const auto& loc : decl_locs) {
                    unresolved_externs_[name].push_back(loc);
                }
            }
        }
    }

    // Also check if newly public symbols resolve any existing externs
    for (const auto& [name, symbol] : module->symbols()) {
        if (symbol.is_public()) {
            // This public symbol may resolve pending externs
            unresolved_externs_.erase(name);
        }
    }
}

Module* Linker::resolve_from_libraries(const std::string& symbol_name) {
    return resolve_with_cycle_detection(symbol_name, 0);
}

Module* Linker::resolve_with_cycle_detection(const std::string& symbol_name,
        int depth) {
    // Check for excessive recursion depth
    if (depth > MAX_RESOLUTION_DEPTH) {
        g_errors.error(Location(), ErrorCode::LinkError,
                       "Circular dependency detected while resolving symbol: " + symbol_name);
        return nullptr;
    }

    // Check if we're already trying to resolve this symbol (direct cycle)
    if (currently_resolving_.find(symbol_name) != currently_resolving_.end()) {
        g_errors.error(Location(), ErrorCode::LinkError,
                       "Circular dependency detected: symbol " + symbol_name +
                       " depends on itself through library modules");
        return nullptr;
    }

    // Mark this symbol as being resolved
    currently_resolving_.insert(symbol_name);

    // Ensure we remove from currently_resolving_ on exit
    struct ResolveGuard {
        std::set<std::string>& set;
        std::string name;
        ResolveGuard(std::set<std::string>& s, const std::string& n) : set(s),
            name(n) {
        }
        ~ResolveGuard() {
            set.erase(name);
        }
    } guard(currently_resolving_, symbol_name);

    // Search libraries in order
    for (Library* library : libraries_) {
        Module* defining_module = library->find_public_symbol(symbol_name);
        if (defining_module) {
            // Check if this library module has already been pulled in
            if (library_modules_pulled_.find(defining_module) ==
                    library_modules_pulled_.end()) {
                // Mark module as pulled in
                library_modules_pulled_.insert(defining_module);

                // Index all public symbols from this library module
                index_module_public_symbols(defining_module);

                // Process any extern dependencies of this module recursively
                for (const auto& [name, symbol] : defining_module->symbols()) {
                    if (symbol.is_extern()) {
                        // Check if still unresolved
                        if (public_symbols_.find(name) == public_symbols_.end()) {
                            // Try to resolve recursively
                            resolve_with_cycle_detection(name, depth + 1);
                        }
                    }
                }
            }

            return defining_module;
        }
    }

    return nullptr;
}

