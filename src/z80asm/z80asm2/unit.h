//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "module.h"

//-----------------------------------------------------------------------------
// CompilationUnit - represents the result of assembling one source file
//-----------------------------------------------------------------------------

class CompilationUnit {
public:
    CompilationUnit() = default;
    CompilationUnit(const std::string& name, const Location& location);
    void clear();

    // Name and location
    const std::string& name() const;
    void set_name(const std::string& name);

    const Location& location() const;
    void set_location(const Location& location);

    // Module management
    const std::vector<std::unique_ptr<Module>>& modules() const;

    // Add module by name - returns existing module or creates new one
    Module* add_module(const std::string& name);

    // Find module by name - returns nullptr if not found
    Module* find_module(const std::string& name);
    const Module* find_module(const std::string& name) const;

    // Current module (last added)
    Module* current_module();
    const Module* current_module() const;

    // Clear all modules and recreate default empty-named module
    void clear_modules();

private:
    std::string name_;
    Location location_;
    std::vector<std::unique_ptr<Module>> modules_;
    Module* current_module_ = nullptr;  // Non-owning pointer to last added module
};

