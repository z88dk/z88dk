//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "unit.h"

//-----------------------------------------------------------------------------
// CompilationUnit implementation
//-----------------------------------------------------------------------------

CompilationUnit::CompilationUnit(const std::string& name,
                                 const Location& location)
    : name_(name), location_(location) {
    // Create the default empty-named module
    add_module("");
}

void CompilationUnit::clear() {
    name_.clear();
    location_.clear();
    modules_.clear();
    current_module_ = nullptr;
}

const std::string& CompilationUnit::name() const {
    return name_;
}

void CompilationUnit::set_name(const std::string& name) {
    name_ = name;
}

const Location& CompilationUnit::location() const {
    return location_;
}

void CompilationUnit::set_location(const Location& location) {
    location_ = location;
}

const std::vector<std::unique_ptr<Module>>& CompilationUnit::modules() const {
    return modules_;
}

Module* CompilationUnit::add_module(const std::string& name) {
    // Check if module already exists
    Module* existing = find_module(name);
    if (existing) {
        current_module_ = existing;  // Update current module pointer
        return existing;              // Return existing module
    }

    // Create new module (heap-allocated for pointer stability)
    auto module = std::make_unique<Module>(name, location_);
    Module* module_ptr = module.get();  // Save pointer before move

    modules_.push_back(std::move(module));

    current_module_ = module_ptr;  // Update current module pointer
    return module_ptr;
}

Module* CompilationUnit::find_module(const std::string& name) {
    for (auto& module : modules_) {
        if (module->name() == name) {
            return module.get();
        }
    }
    return nullptr;
}

const Module* CompilationUnit::find_module(const std::string& name) const {
    for (auto& module : modules_) {
        if (module->name() == name) {
            return module.get();
        }
    }
    return nullptr;
}

Module* CompilationUnit::current_module() {
    return current_module_;
}

const Module* CompilationUnit::current_module() const {
    return current_module_;
}

void CompilationUnit::clear_modules() {
    modules_.clear();
    // Recreate the default empty-named module
    add_module("");
}

