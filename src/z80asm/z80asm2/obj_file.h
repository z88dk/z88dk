//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "cpu.h"
#include "dump_context.h"
#include "obj_expr.h"
#include "obj_extern.h"
#include "obj_modname.h"
#include "obj_module.h"
#include "obj_reloc.h"
#include "obj_section.h"
#include "obj_symbol.h"
#include "obj_symbol_scope.h"
#include "obj_symbol_type.h"
#include "source_loc.h"
#include "strings.h"
#include <cstdint>
#include <memory>
#include <set>
#include <string_view>
#include <vector>

#if 0
struct ObjectLibrary : public TreeNode {
    std::vector<ObjModule> modules;
    std::set<uint> public_symbols;

    ObjectLibrary() = default;
    ObjectLibrary(const ObjectLibrary&) = delete;
    ObjectLibrary& operator=(const ObjectLibrary&) = delete;
    ObjectLibrary(ObjectLibrary&&) = default;
    ObjectLibrary& operator=(ObjectLibrary&&) = default;

    virtual ~ObjectLibrary() = default;
    void dump(DumpContext ctx) const override;
    void clear();
};

bool write_object_library(const ObjectLibrary& obj_lib,
                          std::string_view filename);
bool read_object_library(ObjectLibrary& obj_lib,
                         std::string_view filename);

[[noreturn]]
void dump_obj_lib_and_exit(const ObjectLibrary& obj_lib);
#endif
