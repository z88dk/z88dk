//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_file.h"
#include "cpu.h"
#include <memory>
#include <string_view>

//-----------------------------------------------------------------------------
// object file version
//-----------------------------------------------------------------------------

inline constexpr int MinObjVersion = 1;
inline constexpr int CurObjVersion = 19;

inline constexpr std::string_view ObjFileSignaturePrefix = "Z80RMF";
inline constexpr std::string_view LibFileSignaturePrefix = "Z80LMF";

inline constexpr size_t SignatureSize = 8;

inline constexpr size_t OffsetNotPresent = 0xFFFFFFFF;

inline constexpr int OrgNotDefined = -1;
inline constexpr int OrgSectionSplit = -2;

enum class ObjFileType { None, Object, Library };

std::string_view obj_file_signature();
std::string_view lib_file_signature();

bool parse_signature(std::string_view signature, ObjFileType& type,
                     int& version);

//-----------------------------------------------------------------------------
// Section info
//-----------------------------------------------------------------------------

struct SectionInfo {
    size_t offset = OffsetNotPresent;   // file offset of section
    size_t size = 0;                    // optional, depending on section
    bool present = false;               // convenience
};

//-----------------------------------------------------------------------------
// Object file format
//-----------------------------------------------------------------------------

class ObjFormat {
public:
    ObjFormat(std::shared_ptr<const BinaryFile> file,
              size_t base_offset, size_t object_size);

    std::shared_ptr<const BinaryFile> file() const;
    int version() const;
    int org() const;
    CPU cpu_id() const;
    bool swap_ix_iy() const;
    SectionInfo expressions() const;
    SectionInfo relocations() const;
    SectionInfo defined_symbols() const;
    SectionInfo extern_symbols() const;
    SectionInfo sections() const;
    SectionInfo module_name() const;
    SectionInfo string_table() const;

private:
    std::shared_ptr<const BinaryFile> file_;
    size_t base_offset_ = 0;
    int version_ = 0;
    int org_ = OrgNotDefined;
    CPU cpu_id_ = CPU::none;
    bool swap_ixiy_ = false;
    SectionInfo expressions_;
    SectionInfo relocations_;
    SectionInfo defined_symbols_;
    SectionInfo extern_symbols_;
    SectionInfo module_name_;
    SectionInfo sections_;
    SectionInfo string_table_;
};

//-----------------------------------------------------------------------------
// Library file format
//-----------------------------------------------------------------------------

class LibFormat {
public:
    LibFormat(std::shared_ptr<const BinaryFile> file);

    std::shared_ptr<const BinaryFile> file() const;
    int version() const;
    std::vector<SectionInfo>& modules() const;
    SectionInfo string_table() const;
    SectionInfo symbol_index() const;

private:
    std::shared_ptr<const BinaryFile> file_;
    int version_ = 0;
    std::vector<SectionInfo> modules_;
    SectionInfo string_table_;
    SectionInfo symbol_index_;
};
