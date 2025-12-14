//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "location.h"
#include "module.h"
#include "section.h"
#include "symbols.h"
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

//-----------------------------------------------------------------------------
// Module - represents a object file/module with sections and symbols
//-----------------------------------------------------------------------------
class Module {
public:
    Module(const std::string& name = "", const Location& location = Location());
    void clear();

    // Module identification (name is immutable - it's the key in module collection)
    const std::string& name() const;
    void set_name(const std::string& name);

    // Location of MODULE directive
    const Location& location() const;
    void set_location(const Location& location);

    // Current section (last added, or default empty section if none added)
    Section* current_section();
    const Section* current_section() const;

    // Sections in this module
    const std::vector<std::unique_ptr<Section>>& sections() const;
    Section* add_section(const std::string& name);
    Section* find_section(const std::string& name);
    void clear_sections();

    // Symbol table for all symbols defined in this module
    const std::unordered_map<std::string, Symbol>& symbols() const;

    // Declare a symbol (for PUBLIC, EXTERN, GLOBAL directives)
    // Creates symbol with Undefined type if it doesn't exist
    // Updates scope if symbol exists and scope change is valid
    // Errors:
    //   - Changing scope from non-Local to different scope
    //   - Declaring a defined symbol as Extern
    Symbol* declare_symbol(const std::string& name, const Location& location,
                           SymbolScope scope);

    // Define a symbol (for source code definitions like labels, EQU, etc.)
    // Creates symbol if it doesn't exist
    // Updates undefined symbol if it exists
    // Errors:
    //   - Symbol is already defined
    //   - Symbol is declared as Extern
    Symbol* add_symbol(const std::string& name, const Location& location);
    Symbol* add_symbol(const std::string& name, const Location& location,
                       int value, SymbolType type = SymbolType::Constant);
    Symbol* add_symbol(const std::string& name, const Location& location,
                       Opcode* opcode, int offset,
                       SymbolType type = SymbolType::AddressRelative);

    Symbol* get_symbol(const std::string& name);
    const Symbol* get_symbol(const std::string& name) const;
    bool has_symbol(const std::string& name) const;
    void clear_symbols();

    const std::vector<Location>& get_extern_declarations(const std::string& name)
    const;

private:
    std::string name_;      // Module name
    Location location_;     // Location of MODULE directive
    std::vector<std::unique_ptr<Section>> sections_;    // All sections in this module
    Section* current_section_ = nullptr;    // Pointer to last added section (or default empty section)
    std::unordered_map<std::string, Symbol> symbols_;   // Symbol table (name -> Symbol)

    // Track all declaration locations for error reporting
    std::unordered_map<std::string, std::vector<Location>> extern_declarations_;
};

