//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_file.h"
#include "obj_expr.h"
#include "obj_reloc.h"
#include "obj_symbol.h"
#include "obj_format.h"
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

    ObjFileType type() const override {
        return ObjFileType::Object;
    }

    std::shared_ptr<const BinaryFile> file() const {
        return file_;
    }

    const ObjFormat& obj_format() const {
        return obj_format_;
    }

    int version() const {
        return obj_format_.version;
    }

    const StringsView& strings();
    std::string_view module_name();
    const std::vector<ObjExprView>& exprs();
    const std::vector<ObjRelocView>& relocs();
    const std::vector<ObjSymbolView>& symbols();

private:
    std::shared_ptr<const BinaryFile> file_;
    const ObjFormat obj_format_;

    StringsView strings_;
    bool strings_loaded_ = false;

    std::string_view module_name_;
    bool module_name_loaded_ = false;

    std::vector<ObjExprView> exprs_;
    bool exprs_loaded_ = false;

    std::vector<ObjRelocView> relocs_;
    bool relocs_loaded_ = false;

    std::vector<ObjSymbolView> symbols_;
    bool symbols_loaded_ = false;
};

//-----------------------------------------------------------------------------
// Library file lazy reader
//-----------------------------------------------------------------------------

class LibReader : public ModuleReader {
public:
    explicit LibReader(std::shared_ptr<const BinaryFile> file);

    ObjFileType type() const override {
        return ObjFileType::Library;
    }

    std::shared_ptr<const BinaryFile> file() const {
        return file_;
    }

    const LibFormat& lib_format() const {
        return lib_format_;
    }

    int version() const {
        return lib_format_.version;
    }

    const StringsView& strings();

private:
    std::shared_ptr<const BinaryFile> file_;
    const LibFormat lib_format_;

    StringsView strings_;
    bool strings_loaded_ = false;
};
