//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_data.h"
#include "binary_file.h"
#include "dump_context.h"
#include "obj_expr.h"
#include "obj_extern.h"
#include "obj_modname.h"
#include "obj_module.h"
#include "obj_reloc.h"
#include "obj_schema.h"
#include "obj_section.h"
#include "obj_symbol.h"
#include "strings.h"
#include <memory>
#include <string_view>
#include <vector>

//-----------------------------------------------------------------------------
// Object/Library file lazy reader
//-----------------------------------------------------------------------------

class ModuleReader {
public:
    virtual ObjFileType type() const = 0;
    virtual ~ModuleReader() = default;
};

std::unique_ptr<ModuleReader> read_module_file(std::string_view filename);

//-----------------------------------------------------------------------------
// Object file lazy reader
//-----------------------------------------------------------------------------

class ObjReader : public ModuleReader {
public:
    explicit ObjReader(std::shared_ptr<const BinaryFile> file,
                       size_t base_offset, size_t object_size);

    ObjFileType type() const override;
    std::shared_ptr<const BinaryFile> file() const;
    const ObjSchema& obj_schema() const;
    int version() const;
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
    std::shared_ptr<const BinaryFile> file_;
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

class LibReader : public ModuleReader {
public:
    explicit LibReader(std::shared_ptr<const BinaryFile> file);

    ObjFileType type() const override;
    std::shared_ptr<const BinaryFile> file() const;
    const LibSchema& lib_schema() const;
    int version() const;
    const StringsView& strings();

private:
    std::shared_ptr<const BinaryFile> file_;
    const LibSchema lib_schema_;

    StringsView strings_;
    bool strings_loaded_ = false;
};
