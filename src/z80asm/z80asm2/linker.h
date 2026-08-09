//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "obj_file.h"
#include "strings.h"
#include <memory>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

class ModuleResolver {
public:
    ModuleResolver(const std::vector<std::unique_ptr<ObjFile>>& input_modules,
                   const std::vector<std::unique_ptr<ObjFile>>& input_libraries);

    bool resolve();
    std::vector<ObjModule*> module_sequence() const {
        return module_sequence_;
    }

private:
    const std::vector<std::unique_ptr<ObjFile>>& input_modules_;
    const std::vector<std::unique_ptr<ObjFile>>& input_libraries_;
    std::unordered_map<StringId, ObjModule*> defined_symbols_;
    std::unordered_map<StringId, ObjModule*> undefined_symbols_;
    std::unordered_set<ObjModule*> selected_modules_;
    std::vector<ObjModule*> module_sequence_; // final sequence of modules to link

    bool resolve_symbols();
    bool add_module(ObjModule* module);
    void pull_module_sequence();
};

class SectionLayout;
class RelocationPass;
class OutputWriter;

class LinkerDriver {
public:
    explicit LinkerDriver() = default;

    void add_input_modules(const std::vector<std::string>& filenames);
    void add_input_libraries(const std::vector<std::string>& libraries);
    void set_output_dir(std::string_view output_dir);
    bool link();

private:
    std::vector<std::unique_ptr<ObjFile>> input_modules_;
    std::vector<std::unique_ptr<ObjFile>> input_libraries_;
    std::string output_dir_;
};

bool link_files(const std::vector<std::string>& objects,
                const std::vector<std::string>& libraries,
                std::string_view output_dir);
