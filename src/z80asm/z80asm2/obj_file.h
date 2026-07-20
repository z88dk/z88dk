//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "cpu.h"
#include "dump_context.h"
#include "obj_expr.h"
#include "obj_reloc.h"
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

struct ObjSection : public TreeNode {
    static constexpr int OrgNotDefined = -1;
    static constexpr int OrgSectionSplit = -2;

    uint name_id = 0; // section name
    bool org_defined = false;   // true if ORG defined
    uint base_address = 0;      // ORG if defined
    bool section_split = false; // true if section needs splitting
    uint align = 1;             // alignment address
    std::vector<uint8_t> bytes; // binary data

    virtual ~ObjSection() = default;
    void dump(DumpContext ctx) const override;
};

struct ObjectModule : public TreeNode {
    uint module_name_id = 0;
    CPU cpu_id = CPU::z80;
    bool swap_ix_iy = false;

    std::vector<std::unique_ptr<ObjExpr>> exprs;
    std::vector<std::unique_ptr<ObjReloc>> relocs;
    std::vector<std::unique_ptr<ObjSymbol>> symbols;
    std::vector<uint> externs;
    std::vector<std::unique_ptr<ObjSection>> sections;

    ObjectModule() = default;
    ObjectModule(const ObjectModule&) = delete;
    ObjectModule& operator=(const ObjectModule&) = delete;
    ObjectModule(ObjectModule&&) = default;
    ObjectModule& operator=(ObjectModule&&) = default;

    virtual ~ObjectModule() = default;
    void dump(DumpContext ctx) const override;
    void clear();
};

struct ObjectLibrary : public TreeNode {
    std::vector<std::unique_ptr<ObjectModule>> modules;
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
