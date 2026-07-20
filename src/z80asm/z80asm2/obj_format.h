//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_file.h"
#include "cpu.h"
#include "strings.h"
#include <cstdint>
#include <memory>
#include <string_view>
#include <type_traits>
#include <vector>

//-----------------------------------------------------------------------------
// object file version
//-----------------------------------------------------------------------------

inline constexpr int MinObjVersion = 1;
inline constexpr int CurObjVersion = 19;

inline constexpr std::string_view ObjFileSignaturePrefix = "Z80RMF";
inline constexpr std::string_view LibFileSignaturePrefix = "Z80LMF";

inline constexpr size_t SignatureSize = 8;

inline constexpr uint32_t OffsetNotPresent = 0xFFFFFFFF;

inline constexpr int OrgNotDefined = -1;
inline constexpr int OrgSectionSplit = -2;

enum class ObjFileType { None, Object, Library };

std::string_view obj_file_signature();
std::string_view lib_file_signature();

bool parse_signature(std::string_view signature, ObjFileType& type,
                     int& version);

//-----------------------------------------------------------------------------
// Classes to create View and Interned versions of Object classes
//-----------------------------------------------------------------------------

// non-owning storage
struct ViewStorage {
    using Str = std::string_view;

    static std::string_view to_view(Str s) {
        return s;
    }

    static Str from_view(std::string_view s) {
        return s;   // just store the view
    }
};

// owning storage
struct InternedStorage {
    using Str = uint;

    static std::string_view to_view(Str id) {
        return g_strings.view(id);
    }

    static Str from_view(std::string_view s) {
        return g_strings.intern(s);   // store the interned ID
    }
};

template <typename T>
using EnableInterned =
    std::enable_if_t<std::is_same<T, InternedStorage>::value>;

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

struct ObjFormat {
    explicit ObjFormat(std::shared_ptr<const BinaryFile> file_,
                       size_t base_offset_, size_t object_size);

    std::shared_ptr<const BinaryFile> file;
    size_t base_offset = 0;
    int version = 0;
    int org = OrgNotDefined;
    CPU cpu_id = CPU::none;
    bool swap_ixiy = false;
    SectionInfo exprs;
    SectionInfo relocs;
    SectionInfo symbols;
    SectionInfo externs;
    SectionInfo module_name;
    SectionInfo sections;
    SectionInfo strings;
};

//-----------------------------------------------------------------------------
// Library file format
//-----------------------------------------------------------------------------

struct LibFormat {
    explicit LibFormat(std::shared_ptr<const BinaryFile> file_);

    std::shared_ptr<const BinaryFile> file;
    int version = 0;
    std::vector<SectionInfo> modules;
    SectionInfo strings;
    SectionInfo symbol_index;
};

