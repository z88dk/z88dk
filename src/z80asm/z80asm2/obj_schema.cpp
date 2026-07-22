//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "binary_file.h"
#include "cpu.h"
#include "diag.h"
#include "obj_features.h"
#include "obj_schema.h"
#include "options.h"
#include "string_utils.h"
#include <algorithm>
#include <charconv>
#include <iomanip>
#include <iostream>
#include <memory>
#include <sstream>
#include <string>
#include <system_error>
#include <utility>

//-----------------------------------------------------------------------------
// object file version
//-----------------------------------------------------------------------------

static std::string make_signature(std::string_view prefix, int version) {
    size_t version_width = SignatureSize - ObjFileSignaturePrefix.size();

    std::ostringstream oss;
    oss << prefix << std::setw(version_width) << std::setfill('0') << version;
    return oss.str();
}

std::string_view obj_file_signature() {
    const static std::string sig = make_signature(ObjFileSignaturePrefix,
                                   CurObjVersion);
    return sig;
}

std::string_view lib_file_signature() {
    const static std::string sig = make_signature(LibFileSignaturePrefix,
                                   CurObjVersion);
    return sig;
}

bool parse_signature(std::string_view signature, ObjFileType& type,
                     int& version) {
    // check size
    if (signature.size() != SignatureSize) {
        return false;
    }

    // get type
    size_t prefix_size = ObjFileSignaturePrefix.size();
    if (signature.substr(0, prefix_size) == ObjFileSignaturePrefix) {
        type = ObjFileType::Object;
    }
    else if (signature.substr(0, prefix_size) == LibFileSignaturePrefix) {
        type = ObjFileType::Library;
    }
    else {
        return false;
    }

    // get version
    auto digits = signature.substr(prefix_size, SignatureSize - prefix_size);
    auto [ptr, ec] = std::from_chars(
                         digits.data(),
                         digits.data() + digits.size(),
                         version);
    if (ec != std::errc{} || ptr != digits.data() + digits.size()) {
        return false;	// parse error
    }

    if (version < MinObjVersion || version > CurObjVersion) {
        return false;
    }

    return true;
}

//-----------------------------------------------------------------------------
// Object file format
//-----------------------------------------------------------------------------

static SectionInfo load_offset(std::shared_ptr<const BinaryFile> file,
                               size_t& ptr,
                               size_t base_offset, size_t end_offset,
                               std::string_view pointer_name) {
    size_t offset = file->get_dword(ptr);
    if (offset == OffsetNotPresent) {
        SectionInfo info;
        info.offset = offset;
        info.size = 0;
        info.present = false;
        return info;
    }
    else {
        size_t start_offset = base_offset + offset;
        if (start_offset > end_offset) {
            fatal_error("invalid " + std::string(pointer_name) +
                        " pointer in '" + std::string(file->filename()) +
                        "' offset " + int_to_hex(base_offset));
        }
        SectionInfo info;
        info.offset = start_offset;
        info.size = 0;
        info.present = true;
        return info;
    }
}

static size_t calc_end_offset(const SectionInfo& info, size_t end_offset) {
    if (info.present) {
        return info.offset;
    }
    else {
        return end_offset;
    }
}

ObjSchema::ObjSchema(std::shared_ptr<const BinaryFile> file_,
                     size_t base_offset_, size_t size_)
    : file(std::move(file_)), base_offset(base_offset_), size(size_) {

    // check size
    size_t end_offset = base_offset + size;
    if (end_offset >= file->size()) {
        fatal_error("invalid object file '" + std::string(file->filename()) +
                    "' offset " + int_to_hex(base_offset));
    }

    // get signature, type and version
    std::string_view signature = file->peek_string_view(base_offset,
                                 SignatureSize);
    ObjFileType type = ObjFileType::None;
    if (!parse_signature(signature, type, version) ||
            type != ObjFileType::Object) {
        fatal_error("invalid object file '" + std::string(file->filename()) +
                    "' offset " + int_to_hex(base_offset));
    }

    // get CPU
    size_t ptr = base_offset + SignatureSize;
    if (obj_features(version).has_global_cpu) {
        cpu_id = static_cast<CPU>(file->get_dword(ptr));
        swap_ixiy = !!file->get_dword(ptr);
    }
    else {
        cpu_id = DEFAULT_CPU;
        swap_ixiy = false;
    }

    // get ORG (older versions)
    if (obj_features(version).has_global_org_word) {
        base_address = file->get_word(ptr);
        if (base_address == 0xFFFF) {
            base_address = OrgNotDefined;
        }
    }
    else if (obj_features(version).has_global_org_dword) {
        base_address = file->get_dword(ptr);
    }
    else {
        base_address = OrgNotDefined;
    }

    // get file pointers

    // module name pointer
    modname = load_offset(file, ptr, base_offset_, end_offset, "module name");
    if (!modname.present) {
        fatal_error("missing module name pointer in '" + std::string(file->filename()) +
                    "' offset " + int_to_hex(base_offset_));
    }

    // expressions pointer
    exprs = load_offset(file, ptr, base_offset_, end_offset, "expressions");

    // relocations pointer
    if (obj_features(version).has_relocs) {
        relocs = load_offset(file, ptr, base_offset_, end_offset, "relocs");
    }
    else {
        relocs.offset = OffsetNotPresent;
        relocs.size = 0;
        relocs.present = false;
    }

    // defined symbols pointer
    symbols = load_offset(file, ptr, base_offset_, end_offset,
                          "defined symbols");

    // extern symbols pointer
    externs = load_offset(file, ptr, base_offset_, end_offset,
                          "extern symbols");

    // sections pointer
    sections = load_offset(file, ptr, base_offset_, end_offset, "sections");

    // string table pointer
    if (obj_features(version).has_string_table) {
        strings = load_offset(file, ptr, base_offset_, end_offset,
                              "string table");
    }
    else {
        strings.offset = OffsetNotPresent;
        strings.size = 0;
        strings.present = false;
    }

    // compute sizes of sections
    if (exprs.present) {
        size_t next_offset = std::min( {
            calc_end_offset(relocs, end_offset),
            calc_end_offset(symbols, end_offset),
            calc_end_offset(externs, end_offset),
            modname.offset });
        exprs.size = next_offset - exprs.offset;
    }

    if (relocs.present) {
        size_t next_offset = std::min( {
            calc_end_offset(symbols, end_offset),
            calc_end_offset(externs, end_offset),
            modname.offset });
        relocs.size = next_offset - relocs.offset;
    }

    if (symbols.present) {
        size_t next_offset = std::min( {
            calc_end_offset(externs, end_offset),
            modname.offset });
        symbols.size = next_offset - symbols.offset;
    }

    if (externs.present) {
        size_t next_offset = modname.offset;
        externs.size = next_offset - externs.offset;
    }

    if (sections.present) {
        size_t next_offset = std::min( {
            calc_end_offset(strings, end_offset),
            end_offset });
        sections.size = next_offset - sections.offset;
    }

    if (strings.present) {
        size_t next_offset = end_offset;
        strings.size = next_offset - strings.offset;
    }
}

//-----------------------------------------------------------------------------
// Library file format
//-----------------------------------------------------------------------------

LibSchema::LibSchema(std::shared_ptr<const BinaryFile> file_)
    : file(std::move(file_)), base_offset(0), size(file->size()) {

    size_t end_offset = base_offset + size;
    size_t ptr = base_offset;

    // get signature, type and version
    std::string_view signature = file->get_string_view(ptr, SignatureSize);
    ObjFileType type = ObjFileType::None;
    if (!parse_signature(signature, type, version) ||
            type != ObjFileType::Library) {
        fatal_error("invalid library file '" + std::string(file->filename()) + "'");
    }

    // get file pointers

    // symbol index
    if (obj_features(version).has_symbol_index) {
        symbol_index = load_offset(file, ptr, base_offset, end_offset,
                                   "symbol index");
    }
    else {
        symbol_index.offset = OffsetNotPresent;
        symbol_index.size = 0;
        symbol_index.present = false;
    }

    // string table pointer
    if (obj_features(version).has_string_table) {
        strings = load_offset(file, ptr, base_offset, end_offset,
                              "string table");
    }
    else {
        strings.offset = OffsetNotPresent;
        strings.size = 0;
        strings.present = false;
    }

    // compute sizes of sections
    if (symbol_index.present) {
        size_t next_offset = std::min( {
            calc_end_offset(strings, end_offset),
            end_offset });
        symbol_index.size = next_offset - symbol_index.offset;
    }

    if (strings.present) {
        size_t next_offset = end_offset;
        strings.size = next_offset - strings.offset;
    }

    // object modules
    while (true) {
        size_t next_module = file->get_dword(ptr);
        size_t module_size = file->get_dword(ptr);

        if (next_module != OffsetNotPresent && module_size > end_offset) {
            fatal_error("invalid module pointer in '" + std::string(file->filename()) +
                        "' offset " + int_to_hex(base_offset));
        }

        if (ptr + module_size > end_offset) {
            fatal_error("invalid module size in '" + std::string(file->filename()) +
                        "' offset " + int_to_hex(base_offset));
        }

        if (module_size > 0) {		// not deleted
            size_t end_module = std::min( {
                ptr + module_size,
                symbol_index.present ? symbol_index.offset : end_offset,
                strings.present ? strings.offset : end_offset,
                end_offset });

            SectionInfo info;
            info.offset = ptr;
            info.size = end_module - ptr;
            info.present = true;
            modules.push_back(info);
        }

        if (next_module == OffsetNotPresent) {
            break; 		// last module in chain
        }
        else {
            ptr = next_module;
        }
    }
}
