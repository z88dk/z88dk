//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "obj_format.h"
#include "binary_file.h"
#include "cpu.h"
#include "diag.h"
#include "obj_features.h"
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
                               const std::string& pointer_name) {
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
            fatal_error("invalid " + pointer_name + " pointer in '" +
                        file->filename() + "' offset " + int_to_hex(base_offset));
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

ObjFormat::ObjFormat(std::shared_ptr<const BinaryFile> file,
                     size_t base_offset, size_t object_size)
    : file_(std::move(file)), base_offset_(base_offset) {

    // check size
    size_t end_offset = base_offset + object_size;
    if (end_offset >= file_->size()) {
        fatal_error("invalid object file '" + file_->filename() +
                    "' offset " + int_to_hex(base_offset_));
    }

    // get signature, type and version
    std::string_view signature = file_->peek_string_view(base_offset_,
                                 SignatureSize);
    ObjFileType type = ObjFileType::None;
    if (!parse_signature(signature, type, version_) ||
            type != ObjFileType::Object) {
        fatal_error("invalid object file '" + file_->filename() +
                    "' offset " + int_to_hex(base_offset_));
    }

    // get CPU
    size_t ptr = base_offset_ + SignatureSize;
    if (obj_features(version_).has_global_cpu) {
        cpu_id_ = static_cast<CPU>(file_->get_dword(ptr));
        swap_ixiy_ = !!file_->get_dword(ptr);
    }
    else {
        cpu_id_ = DEFAULT_CPU;
        swap_ixiy_ = false;
    }

    // get ORG (older versions)
    if (obj_features(version_).has_global_org_word) {
        org_ = file_->get_word(ptr);
        if (org_ == 0xFFFF) {
            org_ = OrgNotDefined;
        }
    }
    else if (obj_features(version_).has_global_org_dword) {
        org_ = file_->get_dword(ptr);
    }
    else {
        org_ = OrgNotDefined;
    }

    // get file pointers

    // module name pointer
    module_name_ = load_offset(file_, ptr, base_offset_, end_offset, "module name");
    if (!module_name_.present) {
        fatal_error("missing module name pointer in '" + file_->filename() +
                    "' offset " + int_to_hex(base_offset_));
    }

    // expressions pointer
    expressions_ = load_offset(file_, ptr, base_offset_, end_offset, "expressions");

    // relocations pointer
    if (obj_features(version_).has_relocations) {
        relocations_ = load_offset(file_, ptr, base_offset_, end_offset, "relocations");
    }
    else {
        relocations_.offset = OffsetNotPresent;
        relocations_.size = 0;
        relocations_.present = false;
    }

    // defined symbols pointer
    defined_symbols_ = load_offset(file_, ptr, base_offset_, end_offset,
                                   "defined symbols");

    // extern symbols pointer
    extern_symbols_ = load_offset(file_, ptr, base_offset_, end_offset,
                                  "extern symbols");

    // sections pointer
    sections_ = load_offset(file_, ptr, base_offset_, end_offset, "sections");

    // string table pointer
    if (obj_features(version_).has_string_table) {
        string_table_ = load_offset(file_, ptr, base_offset_, end_offset,
                                    "string table");
    }
    else {
        string_table_.offset = OffsetNotPresent;
        string_table_.size = 0;
        string_table_.present = false;
    }

    // compute sizes of sections
    if (expressions_.present) {
        size_t next_offset = std::min( {
            calc_end_offset(relocations_, end_offset),
            calc_end_offset(defined_symbols_, end_offset),
            calc_end_offset(extern_symbols_, end_offset),
            module_name_.offset });
        expressions_.size = next_offset - expressions_.offset;
    }

    if (relocations_.present) {
        size_t next_offset = std::min( {
            calc_end_offset(defined_symbols_, end_offset),
            calc_end_offset(extern_symbols_, end_offset),
            module_name_.offset });
        relocations_.size = next_offset - relocations_.offset;
    }

    if (defined_symbols_.present) {
        size_t next_offset = std::min( {
            calc_end_offset(extern_symbols_, end_offset),
            module_name_.offset });
        defined_symbols_.size = next_offset - defined_symbols_.offset;
    }

    if (extern_symbols_.present) {
        size_t next_offset = module_name_.offset;
        extern_symbols_.size = next_offset - extern_symbols_.offset;
    }

    if (sections_.present) {
        size_t next_offset = std::min( {
            calc_end_offset(string_table_, end_offset),
            end_offset });
        sections_.size = next_offset - sections_.offset;
    }

    if (string_table_.present) {
        size_t next_offset = end_offset;
        string_table_.size = next_offset - string_table_.offset;
    }
}

//-----------------------------------------------------------------------------
// Library file format
//-----------------------------------------------------------------------------

LibFormat::LibFormat(std::shared_ptr<const BinaryFile> file)
    : file_(std::move(file)) {

    size_t base_offset = 0;
    size_t end_offset = file_->size();
    size_t ptr = base_offset;

    // get signature, type and version
    std::string_view signature = file_->get_string_view(ptr, SignatureSize);
    ObjFileType type = ObjFileType::None;
    if (!parse_signature(signature, type, version_) ||
            type != ObjFileType::Library) {
        fatal_error("invalid library file '" + file_->filename() + "'");
    }

    // get file pointers

    // symbol index
    if (obj_features(version_).has_symbol_index) {
        symbol_index_ = load_offset(file_, ptr, base_offset, end_offset,
                                    "symbol index");
    }
    else {
        symbol_index_.offset = OffsetNotPresent;
        symbol_index_.size = 0;
        symbol_index_.present = false;
    }

    // string table pointer
    if (obj_features(version_).has_string_table) {
        string_table_ = load_offset(file_, ptr, base_offset, end_offset,
                                    "string table");
    }
    else {
        string_table_.offset = OffsetNotPresent;
        string_table_.size = 0;
        string_table_.present = false;
    }

    // compute sizes of sections
    if (symbol_index_.present) {
        size_t next_offset = std::min( {
            calc_end_offset(string_table_, end_offset),
            end_offset });
        symbol_index_.size = next_offset - symbol_index_.offset;
    }

    if (string_table_.present) {
        size_t next_offset = end_offset;
        string_table_.size = next_offset - string_table_.offset;
    }

    // object modules
    while (true) {
        size_t next_module = file_->get_dword(ptr);
        size_t module_size = file_->get_dword(ptr);

        if (next_module != OffsetNotPresent && module_size > end_offset) {
            fatal_error("invalid module pointer in '" + file_->filename() +
                        "' offset " + int_to_hex(base_offset));
        }

        if (ptr + module_size > end_offset) {
            fatal_error("invalid module size in '" + file_->filename() +
                        "' offset " + int_to_hex(base_offset));
        }

        if (module_size > 0) {		// not deleted
            size_t end_module = std::min( {
                ptr + module_size,
                symbol_index_.present ? symbol_index_.offset : end_offset,
                string_table_.present ? string_table_.offset : end_offset,
                end_offset });

            SectionInfo info;
            info.offset = ptr;
            info.size = end_module - ptr;
            info.present = true;
            modules_.push_back(info);
        }

        if (next_module == OffsetNotPresent) {
            break; 		// last module in chain
        }
        else {
            ptr = next_module;
        }
    }
}
