//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "obj_file.h"
#include "strings.h"
#include <cstdint>
#include <memory>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

struct LinkedSymbol {
    ObjSymbol* def = nullptr;       // where it was defined
    ObjectModule* module = nullptr;
    bool resolved = false;
    int value = 0;                  // final linked value
};

struct LinkedSection {
    uint name_id;
    uint start_address;
    uint size;
    std::vector<uint8_t> data;
    std::vector<ObjExpr*> relocs;
};

struct LinkContext {
    // Input object libraries and modules; they own the ObjectLibrary's and ObjectModule's
    std::vector<std::unique_ptr<ObjectLibrary>> input_modules;
    std::vector<std::unique_ptr<ObjectLibrary>> libraries;

    // Library index
    std::unordered_map<uint, ObjectModule*> symbol_to_module;

    // Linking state
    std::unordered_map<uint, LinkedSymbol> global_symbols;
    std::unordered_set<uint> unresolved_symbols;
    std::unordered_set<ObjectModule*> selected_modules;
    std::vector<ObjectModule*> final_modules;

    // Output sections
    std::vector<LinkedSection> linked_sections;
};

void link_files(const std::vector<std::string>& filenames,
                const std::vector<std::string>& libraries,
                const std::vector<std::string>& library_paths,
                std::string_view output_dir);
