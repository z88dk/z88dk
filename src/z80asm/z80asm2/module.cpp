//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "module.h"
#include "section.h"

//-----------------------------------------------------------------------------
// Module implementation
//-----------------------------------------------------------------------------

Module::Module(const std::string& name, const Location& location)
    : name_(name), location_(location) {
    // Create the default empty-named section
    clear_sections();
}

void Module::clear() {
    name_.clear();
    location_.clear();
    clear_sections();
    clear_symbols();
}

const std::string& Module::name() const {
    return name_;
}

void Module::set_name(const std::string& name) {
    name_ = name;
}

const Location& Module::location() const {
    return location_;
}

void Module::set_location(const Location& location) {
    location_ = location;
}

Section* Module::current_section() {
    return current_section_;
}

const Section* Module::current_section() const {
    return current_section_;
}

const std::vector<std::unique_ptr<Section>>& Module::sections() const {
    return sections_;
}

Section* Module::add_section(const std::string& name) {
    // Check if section already exists
    Section* existing = find_section(name);
    if (existing) {
        current_section_ = existing;  // Update current section pointer
        return existing;              // Return existing section
    }

    // Add new section (heap-allocated for pointer stability)
    // Section constructor already adds an empty opcode
    sections_.push_back(std::make_unique<Section>(name));
    current_section_ = sections_.back().get();  // Update current section pointer
    return current_section_;
}

Section* Module::find_section(const std::string& name) {
    for (auto& section : sections_) {
        if (section->name() == name) {
            return section.get();
        }
    }
    return nullptr;
}

void Module::clear_sections() {
    sections_.clear();
    // Recreate the default empty-named section
    sections_.push_back(std::make_unique<Section>(""));
    current_section_ = sections_.back().get();
}

const std::unordered_map<std::string, Symbol>& Module::symbols() const {
    return symbols_;
}

Symbol* Module::get_symbol(const std::string& name) {
    auto it = symbols_.find(name);
    if (it != symbols_.end()) {
        return &it->second;
    }
    return nullptr;
}

const Symbol* Module::get_symbol(const std::string& name) const {
    auto it = symbols_.find(name);
    if (it != symbols_.end()) {
        return &it->second;
    }
    return nullptr;
}

bool Module::has_symbol(const std::string& name) const {
    return symbols_.find(name) != symbols_.end();
}

void Module::clear_symbols() {
    symbols_.clear();
    extern_declarations_.clear();
}

const std::vector<Location>& Module::get_extern_declarations(
    const std::string& name) const {
    static const std::vector<Location> empty;
    auto it = extern_declarations_.find(name);
    return (it != extern_declarations_.end()) ? it->second : empty;
}

//-----------------------------------------------------------------------------
// Module symbol management
//-----------------------------------------------------------------------------

Symbol* Module::declare_symbol(const std::string& name,
                               const Location& location, SymbolScope scope) {
    // Track extern declaration locations for error reporting
    if (scope == SymbolScope::Extern) {
        extern_declarations_[name].push_back(location);
    }

    // Find or create symbol
    auto it = symbols_.find(name);
    if (it == symbols_.end()) {
        // Create new undefined symbol with requested scope
        symbols_.emplace(name, Symbol(name, location));
        it = symbols_.find(name);
        it->second.set_scope(scope);
        return &it->second;
    }

    Symbol* sym = &it->second;
    SymbolScope current_scope = sym->scope();

    // Same scope - OK (idempotent)
    if (current_scope == scope) {
        return sym;
    }

    // Check for invalid EXTERN declaration of defined symbol (must come early)
    if (scope == SymbolScope::Extern && sym->is_defined()) {
        g_errors.error(location, ErrorCode::SymbolRedefined, name +
                       " (cannot declare defined symbol as EXTERN)");
        return sym;
    }

    // Allow Local to be upgraded to any other scope
    if (current_scope == SymbolScope::Local) {
        sym->set_scope(scope);
        return sym;
    }

    // Allow Global to transition to Public or Extern
    if (current_scope == SymbolScope::Global &&
            (scope == SymbolScope::Public || scope == SymbolScope::Extern)) {
        sym->set_scope(scope);
        return sym;
    }

    // Otherwise, it's a scope conflict
    g_errors.error(location, ErrorCode::SymbolRedefined, name);
    return sym;  // Return existing symbol despite error
}

Symbol* Module::add_symbol(const std::string& name, const Location& location) {
    auto it = symbols_.find(name);

    if (it != symbols_.end()) {
        // Symbol already exists
        Symbol& existing = it->second;

        // Error if symbol is already defined
        if (existing.is_defined()) {
            g_errors.error(location, ErrorCode::SymbolRedefined, name);
            return &existing;
        }

        // Error if trying to define an explicitly EXTERN symbol (not Global)
        if (existing.scope() == SymbolScope::Extern) {
            g_errors.error(location, ErrorCode::SymbolRedefined,
                           name + " (cannot define EXTERN symbol)");
            return &existing;
        }

        // Update location for the definition
        existing.set_location(location);
        return &existing;
    }

    // Symbol doesn't exist - create it
    auto result = symbols_.emplace(name, Symbol(name, location));
    return &result.first->second;
}

Symbol* Module::add_symbol(const std::string& name, const Location& location,
                           int value, SymbolType type) {
    // Delegate common logic to the basic overload
    Symbol* sym = add_symbol(name, location);
    if (!sym) {
        return nullptr;
    }

    // If the symbol was already defined or marked EXTERN, the basic overload
    // has already reported the appropriate error. Do not mutate further.
    if (sym->is_defined() || sym->scope() == SymbolScope::Extern) {
        return sym;
    }

    // Apply definition
    sym->set_value(value);
    sym->set_type(type);
    sym->set_location(location);

    return sym;
}

Symbol* Module::add_symbol(const std::string& name, const Location& location,
                           Opcode* opcode, int offset, SymbolType type) {
    // Delegate common logic to the basic overload
    Symbol* sym = add_symbol(name, location);
    if (!sym) {
        return nullptr;
    }

    // If the symbol was already defined or marked EXTERN, the basic overload
    // has already reported the appropriate error. Do not mutate further.
    if (sym->is_defined() || sym->scope() == SymbolScope::Extern) {
        return sym;
    }

    // Apply definition
    sym->set_opcode(opcode);
    sym->set_offset(offset);
    sym->set_type(type);
    sym->set_location(location);

    return sym;
}
