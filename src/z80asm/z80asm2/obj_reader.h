//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_data.h"
#include "binary_file.h"
#include "dump_context.h"
#include "lib_module.h"
#include "obj_expr.h"
#include "obj_extern.h"
#include "obj_modname.h"
#include "obj_module.h"
#include "obj_reloc.h"
#include "obj_schema.h"
#include "obj_section.h"
#include "obj_symbol.h"
#include "strings.h"
#include <functional>
#include <memory>
#include <string_view>
#include <unordered_map>
#include <vector>

//-----------------------------------------------------------------------------
// Object/Library file lazy reader
//-----------------------------------------------------------------------------

class ModuleReader {
public:
    virtual ~ModuleReader() = default;
    virtual ObjFileType type() const = 0;
};

std::unique_ptr<ModuleReader> read_module_file(std::string_view filename);

//-----------------------------------------------------------------------------
// Object file lazy reader
//-----------------------------------------------------------------------------

class ObjReader : public ModuleReader {
public:
    explicit ObjReader(std::shared_ptr<const BinaryFile> file,
                       size_t base_offset, size_t object_size);

    const ObjSchema& obj_schema() const {
        return obj_schema_;
    }
    std::shared_ptr<const BinaryFile> file() const {
        return obj_schema_.file;
    }
    size_t base_offset() const {
        return obj_schema_.base_offset;
    }
    size_t size() const {
        return obj_schema_.size;
    }
    ObjFileType type() const override {
        return obj_schema_.type;
    }
    int version() const {
        return obj_schema_.version;
    }

    const StringsView& strings();
    const ObjModuleView& module();
    const ObjModnameView& modname();
    const std::vector<ObjExprView>& exprs();
    const std::vector<ObjRelocView>& relocs();
    const std::vector<ObjSymbolView>& symbols();
    const std::vector<ObjExternView>& externs();
    const std::vector<ObjSectionView>& sections();

    ObjModule to_obj_module();

private:
    const ObjSchema obj_schema_;
    StringsView strings_;
    bool strings_loaded_ = false;
    ObjModuleView module_;
};

void dump_module(DumpContext ctx, const ObjModule& mod);
void dump_module_short(const ObjModule& mod);
void pack_module(BinaryData& bin_data, const ObjModule& mod);

//-----------------------------------------------------------------------------
// Library file lazy reader
//-----------------------------------------------------------------------------

// symbol index key
struct CpuKey {
    CPU cpu_id;
    bool swap_ixiy;

    bool operator==(const CpuKey& other) const {
        return cpu_id == other.cpu_id && swap_ixiy == other.swap_ixiy;
    }
};

struct CpuKeyHash {
    std::size_t operator()(const CpuKey& k) const {
        return (static_cast<unsigned>(k.cpu_id) << 1) |
               static_cast<unsigned>(k.swap_ixiy);
    }
};

// map string interned ID to offset in file
using SymbolModule = std::unordered_map<uint, size_t>;

// map pair {cpu_id, swap_ixiy} to SymbolModule table
using SymbolIndex = std::unordered_map<CpuKey, SymbolModule, CpuKeyHash>;

class LibReader : public ModuleReader {
public:
    explicit LibReader(std::shared_ptr<const BinaryFile> file);

    const LibSchema& lib_schema() const {
        return lib_schema_;
    }
    std::shared_ptr<const BinaryFile> file() const {
        return lib_schema_.file;
    }
    size_t base_offset() const {
        return lib_schema_.base_offset;
    }
    size_t size() const {
        return lib_schema_.size;
    }
    ObjFileType type() const override {
        return lib_schema_.type;
    }
    int version() const {
        return lib_schema_.version;
    }

    const StringsView& strings();
    const SymbolIndex& symbol_index();

    LibModule to_lib_module();

private:
    const LibSchema lib_schema_;
    StringsView strings_;
    bool strings_loaded_ = false;
    LibModuleView library_;
    SymbolIndex symbol_index_;
    bool symbol_index_loaded_ = false;

    void load_symbol_index();
    void build_symbol_index();
};
