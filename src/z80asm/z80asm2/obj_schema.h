//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_file.h"
#include "cpu.h"
#include "options.h"
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

// need to ensure that uint is 32 bits, since we use it for file offsets and IDs
static_assert(sizeof(uint) == sizeof(uint32_t));

inline constexpr uint OffsetNotPresent = static_cast<uint>(-1);
inline constexpr uint OrgNotDefined = static_cast<uint>(-1);
inline constexpr uint OrgSectionSplit = static_cast<uint>(-2);

enum class ObjFileType { None, Object, Library };

std::string_view obj_file_signature();
std::string_view lib_file_signature();

bool parse_signature(std::string_view signature, ObjFileType& type,
                     int& version);

//-----------------------------------------------------------------------------
// Classes to create View and Interned versions of Object classes
//-----------------------------------------------------------------------------

class BytesView {
public:
    BytesView(const uint8_t* data = nullptr, size_t size = 0)
        : data_(data), size_(size) {}

    const uint8_t* data() const {
        return data_;
    }
    size_t size() const {
        return size_;
    }

    bool empty() const {
        return size_ == 0;
    }

private:
    const uint8_t* data_;
    size_t size_;
};

// non-owning storage
struct ViewStorage {
    using Str = std::string_view;
    using Bytes = BytesView;

    // strings
    static std::string_view to_view(Str s) {
        return s;
    }
    static Str from_view(std::string_view s) {
        return s;   // just store the view
    }

    // bytes
    static BytesView to_view(const Bytes& b) {
        return b;
    }
    static Bytes from_view(BytesView b) {
        return b;
    }
};

// owning storage
struct InternedStorage {
    using Str = uint;
    using Bytes = std::vector<uint8_t>;

    // strings
    static std::string_view to_view(Str id) {
        return g_strings.view(id);
    }
    static Str from_view(std::string_view s) {
        return g_strings.intern(s);   // store the interned ID
    }

    // bytes
    static BytesView to_view(const Bytes& b) {
        return BytesView(b.data(), b.size());
    }
    static Bytes from_view(BytesView b) {
        return Bytes(b.data(), b.data() + b.size());
    }
};

// eager loading wrapper
template <typename T>
using Eager = T;

// lazy loading wrapper
template <typename T>
struct Lazy {
    T value;
    bool loaded = false;
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

struct ObjSchema {
    explicit ObjSchema(std::shared_ptr<const BinaryFile> file_,
                       size_t base_offset_, size_t size_);

    std::shared_ptr<const BinaryFile> file;
    size_t base_offset = 0;
	size_t size = 0;
    int version = 0;
	
    uint base_address = OrgNotDefined;
    CPU cpu_id = DEFAULT_CPU;
    bool swap_ixiy = false;
	
    SectionInfo exprs;
    SectionInfo relocs;
    SectionInfo symbols;
    SectionInfo externs;
    SectionInfo modname;
    SectionInfo sections;
    SectionInfo strings;
};

//-----------------------------------------------------------------------------
// Library file format
//-----------------------------------------------------------------------------

struct LibSchema {
    explicit LibSchema(std::shared_ptr<const BinaryFile> file_);

    std::shared_ptr<const BinaryFile> file;
    size_t base_offset = 0;
	size_t size = 0;
    int version = 0;
	
    std::vector<SectionInfo> modules;
    SectionInfo strings;
    SectionInfo symbol_index;
};

