//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "binary_data.h"
#include "binary_file.h"
#include "diag.h"
#include "obj_expr.h"
#include "obj_features.h"
#include "obj_format.h"
#include "obj_reader.h"
#include "obj_reloc.h"
#include "obj_symbol.h"
#include "release_assert.h"
#include "strings.h"
#include <memory>
#include <string>
#include <utility>
#include <vector>

//-----------------------------------------------------------------------------
// Object/Library file lazy reader
//-----------------------------------------------------------------------------

std::unique_ptr<ModuleReader> read_module_file(std::string_view filename) {
    // create binary file
    auto file = std::make_shared<const BinaryFile>(filename);

    // read signature
    std::string_view signature = file->peek_string_view(0, SignatureSize);
    ObjFileType type = ObjFileType::None;
    int version = 0;
    if (!parse_signature(signature, type, version)) {
        fatal_error("invalid object or library file '" +
                    std::string(file->filename()) + "'");
    }

    // construct respective object
    switch (type) {
    case ObjFileType::Object:
        return std::make_unique<ObjReader>(file, 0, file->size());

    case ObjFileType::Library:
        return std::make_unique<LibReader>(file);

    default:
        release_assert(0);
        return nullptr;
    }
}

//-----------------------------------------------------------------------------
// Object file lazy reader
//-----------------------------------------------------------------------------

ObjReader::ObjReader(std::shared_ptr<const BinaryFile> file,
                     size_t base_offset, size_t object_size)
    : file_(std::move(file)), obj_format_(file_, base_offset, object_size) {
}

const StringsView& ObjReader::strings() {
    if (!strings_loaded_) {
        if (obj_features(version()).has_string_table) {
            strings_.unpack(file_, obj_format_.strings.offset);
        }
        strings_loaded_ = true;
    }

    return strings_;
}

std::string_view ObjReader::module_name() {
    if (!module_name_loaded_) {
        size_t ptr = obj_format_.module_name.offset;
        if (obj_features(version()).has_string_table) {
            uint id = file_->get_dword(ptr);
            module_name_ = strings().view(id);
        }
        else if (obj_features(version()).has_word_strings) {
            module_name_ = file_->get_word_string_view(ptr);
        }
        else {
            module_name_ = file_->get_byte_string_view(ptr);
        }
        module_name_loaded_ = true;
    }

    return module_name_;
}

const std::vector<ObjExprView>& ObjReader::exprs() {
    if (!exprs_loaded_) {
        if (obj_format_.exprs.present) {
            size_t ptr = obj_format_.exprs.offset;
            size_t end_offset = obj_format_.exprs.offset +
                                obj_format_.exprs.size;
            ObjExprView::unpack_exprs(file_, version(), strings(),
                                      ptr, end_offset,
                                      exprs_);
        }
        exprs_loaded_ = true;
    }

    return exprs_;
}

const std::vector<ObjRelocView>& ObjReader::relocs() {
    if (!relocs_loaded_) {
        if (obj_format_.relocs.present) {
            size_t ptr = obj_format_.relocs.offset;
            size_t end_offset = obj_format_.relocs.offset +
                                obj_format_.relocs.size;
            ObjRelocView::unpack_relocs(file_, version(), strings(),
                                        ptr, end_offset,
                                        relocs_);
        }
        relocs_loaded_ = true;
    }

    return relocs_;
}

const std::vector<ObjSymbolView>& ObjReader::symbols() {
    if (!symbols_loaded_) {
        if (obj_format_.symbols.present) {
            size_t ptr = obj_format_.symbols.offset;
            size_t end_offset = obj_format_.symbols.offset +
                                obj_format_.symbols.size;
            ObjSymbolView::unpack_symbols(file_, version(), strings(),
                                          ptr, end_offset,
                                          symbols_);
        }
        symbols_loaded_ = true;
    }

    return symbols_;
}

//-----------------------------------------------------------------------------
// Library file lazy reader
//-----------------------------------------------------------------------------

LibReader::LibReader(std::shared_ptr<const BinaryFile> file)
    : file_(std::move(file)), lib_format_(file_) {
}

const StringsView& LibReader::strings() {
    if (!strings_loaded_) {
        if (obj_features(version()).has_string_table) {
            strings_.unpack(file_, lib_format_.strings.offset);
        }
        strings_loaded_ = true;
    }

    return strings_;
}

