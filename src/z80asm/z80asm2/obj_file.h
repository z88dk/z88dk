//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_data.h"
#include "binary_file.h"
#include "cpu.h"
#include "dump_context.h"
#include "obj_range_type.h"
#include "obj_symbol_scope.h"
#include "obj_symbol_type.h"
#include "options.h"
#include "source_loc.h"
#include "strings.h"
#include <cstdint>
#include <memory>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

//-----------------------------------------------------------------------------
// object file version
//-----------------------------------------------------------------------------

inline constexpr int MinObjVersion = 1;
inline constexpr int CurObjVersion = 19;

inline constexpr std::string_view ObjFileSignaturePrefix = "Z80RMF";
inline constexpr std::string_view LibFileSignaturePrefix = "Z80LMF";

inline constexpr size_t SignatureSize = 8;

inline constexpr uint32_t OffsetNotPresent = static_cast<uint32_t>(-1);
inline constexpr uint32_t OrgNotDefined = static_cast<uint32_t>(-1);
inline constexpr uint32_t OrgSectionSplit = static_cast<uint32_t>(-2);

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
    bool present = false;               // section is present in file
    bool loaded = false;                // section has been loaded into memory

    SectionInfo() = default;
    SectionInfo(size_t offset_, size_t size_ = 0, bool present_ = true)
        : offset(offset_), size(size_), present(present_) {}
};

//-----------------------------------------------------------------------------
// Object and library file schema
//-----------------------------------------------------------------------------

struct CommonSchema {
    std::shared_ptr<const BinaryFile> file;
    size_t base_offset = 0;
    size_t size = 0;
    ObjFileType type = ObjFileType::None;
    int version = 0;
    CPU cur_cpu_id = DEFAULT_CPU;
    bool cur_swap_ixiy = false;

    explicit CommonSchema(std::shared_ptr<const BinaryFile> file_,
                          size_t base_offset_, size_t size_);

    size_t offset_after_signature() const {
        return base_offset + SignatureSize;
    }
    size_t end_offset() const {
        return base_offset + size;
    }
    std::string_view filename() const {
        return file->filename();
    }

    [[noreturn]]
    void invalid_file_error(std::string_view message) const;

protected:
    SectionInfo load_offset(size_t& ptr, std::string_view pointer_name) const;
    static size_t calc_end_offset(const SectionInfo& info, size_t next_offset) {
        return info.present ? info.offset : next_offset;
    };
};

//-----------------------------------------------------------------------------

struct ObjSchema : public CommonSchema {
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

    explicit ObjSchema(std::shared_ptr<const BinaryFile> file_,
                       size_t base_offset_, size_t size_);
};

//-----------------------------------------------------------------------------

struct LibSchema : public CommonSchema {
    std::vector<SectionInfo> modules;
    std::unordered_map<size_t, size_t> offset_to_index;
    bool modules_loaded = false;
    SectionInfo strings;
    SectionInfo symbol_index;

    explicit LibSchema(std::shared_ptr<const BinaryFile> file_);
};

//-----------------------------------------------------------------------------
// Module name
//-----------------------------------------------------------------------------

struct ObjModname {
    StringId name_id;       // module name

    std::string_view name() const {
        return g_strings.view(name_id);
    }
    void set_name(std::string_view name) {
        name_id = g_strings.intern(name);
    }

#ifdef _DEBUG
    void dump(DumpContext ctx) const;
#endif
    void dump_short() const;
    size_t pack(BinaryData& bin_data, StringTable& strings) const;
    void unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringTable& strings, size_t ptr);
};

//-----------------------------------------------------------------------------
// Expression
//-----------------------------------------------------------------------------

struct ObjExpr {
    ObjRangeType range = ObjRangeType::Undefined;
    StringId filename_id;
    uint line = 0;

    StringId section_name_id;
    uint asmpc = 0;
    uint patch_ptr = 0;
    uint opcode_size = 0;

    StringId target_name_id;
    StringId text_id;

    std::string_view filename() const {
        return g_strings.view(filename_id);
    }
    std::string_view filename_str() const {
        return filename_id.empty() ? "\"\"" : g_strings.view(filename_id);
    }
    void set_filename(std::string_view filename) {
        filename_id = g_strings.intern(filename);
    }
    std::string_view section_name() const {
        return g_strings.view(section_name_id);
    }
    std::string_view section_name_str() const {
        return section_name_id.empty() ? "\"\"" : g_strings.view(section_name_id);
    }
    void set_section_name(std::string_view section_name) {
        section_name_id = g_strings.intern(section_name);
    }
    std::string_view target_name() const {
        return g_strings.view(target_name_id);
    }
    void set_target_name(std::string_view target_name) {
        target_name_id = g_strings.intern(target_name);
    }
    std::string_view text() const {
        return g_strings.view(text_id);
    }
    void set_text(std::string_view text) {
        text_id = g_strings.intern(text);
    }

#ifdef _DEBUG
    void dump(DumpContext ctx) const;
    static void dump_exprs(DumpContext ctx,
                           const std::vector<ObjExpr>& exprs);
#endif
    void dump_short() const;
    static void dump_exprs_short(const std::vector<ObjExpr>& exprs);

    void pack(BinaryData& bin_data, StringTable& strings) const;
    static size_t pack_exprs(BinaryData& bin_data, StringTable& strings,
                             const std::vector<ObjExpr>& exprs);
    bool unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringTable& strings, size_t& ptr, StringId& last_filename_id);
    static void unpack_exprs(std::shared_ptr<const BinaryFile> file, int version,
                             const StringTable& strings, size_t ptr, size_t end_ptr,
                             std::vector<ObjExpr>& exprs);
};

//-----------------------------------------------------------------------------
// Relocation
//-----------------------------------------------------------------------------

struct ObjReloc {
    ObjRangeType range = ObjRangeType::Undefined;
    StringId filename_id;
    uint line = 0;

    StringId patch_section_name_id;
    uint patch_ptr = 0;             // offset to patch_section_name_id

    StringId value_section_name_id;
    uint offset = 0;                // offset to value_section_name_id

    std::string_view filename() const {
        return g_strings.view(filename_id);
    }
    std::string_view filename_str() const {
        return filename_id.empty() ? "\"\"" : g_strings.view(filename_id);
    }
    void set_filename(std::string_view filename) {
        filename_id = g_strings.intern(filename);
    }
    std::string_view patch_section_name() const {
        return g_strings.view(patch_section_name_id);
    }
    std::string_view patch_section_name_str() const {
        return patch_section_name_id.empty() ? "\"\"" : g_strings.view(
                   patch_section_name_id);
    }
    void set_patch_section_name(std::string_view section_name) {
        patch_section_name_id = g_strings.intern(section_name);
    }
    std::string_view value_section_name() const {
        return g_strings.view(value_section_name_id);
    }
    std::string_view value_section_name_str() const {
        return value_section_name_id.empty() ? "\"\"" : g_strings.view(
                   value_section_name_id);
    }
    void set_value_section_name(std::string_view section_name) {
        value_section_name_id = g_strings.intern(section_name);
    }

#ifdef _DEBUG
    void dump(DumpContext ctx) const;
    static void dump_relocs(DumpContext ctx,
                            const std::vector<ObjReloc>& relocs);
#endif
    void dump_short() const;
    static void dump_relocs_short(const std::vector<ObjReloc>& relocs);

    void pack(BinaryData& bin_data, StringTable& strings) const;
    static size_t pack_relocs(BinaryData& bin_data, StringTable& strings,
                              const std::vector<ObjReloc>& relocs);
    bool unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringTable& strings, size_t& ptr);
    static void unpack_relocs(std::shared_ptr<const BinaryFile> file, int version,
                              const StringTable& strings, size_t ptr, size_t end_ptr,
                              std::vector<ObjReloc>& relocs);
};

//-----------------------------------------------------------------------------
// Symbol
//-----------------------------------------------------------------------------

struct ObjSymbol {
    StringId symbol_name_id;
    StringId filename_id;
    uint line = 0;

    ObjSymbolScope scope = ObjSymbolScope::Undefined;
    ObjSymbolType type = ObjSymbolType::Undefined;

    int value;
    StringId section_name_id;

    std::string_view symbol_name() const {
        return g_strings.view(symbol_name_id);
    }
    void set_symbol_name(std::string_view symbol_name) {
        symbol_name_id = g_strings.intern(symbol_name);
    }
    std::string_view filename() const {
        return g_strings.view(filename_id);
    }
    std::string_view filename_str() const {
        return filename_id.empty() ? "\"\"" : g_strings.view(filename_id);
    }
    void set_filename(std::string_view filename) {
        filename_id = g_strings.intern(filename);
    }
    std::string_view section_name() const {
        return g_strings.view(section_name_id);
    }
    std::string_view section_name_str() const {
        return section_name_id.empty() ? "\"\"" : g_strings.view(section_name_id);
    }
    void set_section_name(std::string_view section_name) {
        section_name_id = g_strings.intern(section_name);
    }

#ifdef _DEBUG
    void dump(DumpContext ctx) const;
    static void dump_symbols(DumpContext ctx,
                             const std::vector<ObjSymbol>& symbols);
#endif
    void dump_short() const;
    static void dump_symbols_short(const std::vector<ObjSymbol>& symbols);

    void pack(BinaryData& bin_data, StringTable& strings) const;
    static size_t pack_symbols(BinaryData& bin_data, StringTable& strings,
                               const std::vector<ObjSymbol>& symbols);
    bool unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringTable& strings, size_t& ptr);
    static void unpack_symbols(std::shared_ptr<const BinaryFile> file, int version,
                               const StringTable& strings, size_t ptr, size_t end_ptr,
                               std::vector<ObjSymbol>& symbols);
};

//-----------------------------------------------------------------------------
// Extern
//-----------------------------------------------------------------------------

struct ObjExtern {
    StringId symbol_name_id;

    std::string_view symbol_name() const {
        return g_strings.view(symbol_name_id);
    }

    void set_symbol_name(std::string_view symbol_name) {
        symbol_name_id = g_strings.intern(symbol_name);
    }

#ifdef _DEBUG
    void dump(DumpContext ctx) const;
    static void dump_externs(DumpContext ctx,
                             const std::vector<ObjExtern>& externs);
#endif
    void dump_short() const;
    static void dump_externs_short(const std::vector<ObjExtern>& externs);

    void pack(BinaryData& bin_data, StringTable& strings) const;
    static size_t pack_externs(BinaryData& bin_data, StringTable& strings,
                               const std::vector<ObjExtern>& externs);
    bool unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringTable& strings, size_t& ptr);
    static void unpack_externs(std::shared_ptr<const BinaryFile> file, int version,
                               const StringTable& strings, size_t ptr, size_t end_ptr,
                               std::vector<ObjExtern>& externs);
};

//-----------------------------------------------------------------------------
// Section
//-----------------------------------------------------------------------------

struct ObjSection {
    StringId section_name_id;
    uint base_address = OrgNotDefined;
    uint align = 1;
    std::vector<uint8_t> bytes;

    std::string_view section_name() const {
        return g_strings.view(section_name_id);
    }
    std::string_view  section_name_str() const {
        return section_name_id.empty() ? "\"\"" : g_strings.view(section_name_id);
    }
    void set_section_name(std::string_view section_name) {
        section_name_id = g_strings.intern(section_name);
    }

#ifdef _DEBUG
    void dump(DumpContext ctx) const;
    static void dump_sections(DumpContext ctx,
                              const std::vector<ObjSection>& sections);
#endif
    void dump_short() const;
    static void dump_sections_short(const std::vector<ObjSection>& sections);

    void pack(BinaryData& bin_data, StringTable& strings) const;
    static size_t pack_sections(BinaryData& bin_data, StringTable& strings,
                                const std::vector<ObjSection>& sections);
    bool unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringTable& strings, size_t& ptr);
    static void unpack_sections(std::shared_ptr<const BinaryFile> file, int version,
                                const StringTable& strings, size_t ptr, size_t end_ptr,
                                std::vector<ObjSection>& sections);

private:
    void print_bytes(DumpContext ctx) const;
};

//-----------------------------------------------------------------------------
// Module
//-----------------------------------------------------------------------------

class ObjModule {
public:
    StringId filename_id() const {
        return filename_id_;
    }
    void set_filename_id(StringId id) {
        filename_id_ = id;
    }
    std::string_view filename() const {
        return g_strings.view(filename_id_);
    }
    void set_filename(std::string_view filename) {
        filename_id_ = g_strings.intern(filename);
    }
    size_t base_offset() const {
        return base_offset_;
    }
    void set_base_offset(size_t offset) {
        base_offset_ = offset;
    }
    CPU cpu_id() const {
        return cpu_id_;
    }
    void set_cpu_id(CPU id) {
        cpu_id_ = id;
    }
    bool swap_ixiy() const {
        return swap_ixiy_;
    }
    void set_swap_ixiy(bool swap) {
        swap_ixiy_ = swap;
    }
    uint base_address() const {
        return base_address_;
    }
    void set_base_address(uint address) {
        base_address_ = address;
    }
    StringId read_string_id(size_t& ptr);
    bool defines_public_symbol(StringId sym_name_id);

    // accessors load sections on demand, if not already loaded
    StringTable* strings();
    ObjModname* modname();
    std::vector<ObjExpr>* exprs();
    std::vector<ObjReloc>* relocs();
    std::vector<ObjSymbol>* symbols();
    std::vector<ObjExtern>* externs();
    std::vector<ObjSection>* sections();

#ifdef _DEBUG
    void dump_loaded_sections(DumpContext ctx);
    void dump(DumpContext ctx);
#endif
    void dump_short();

    void pack(BinaryData& bin_data);
    void unpack(std::shared_ptr<const BinaryFile> file, size_t ptr);

private:
    StringId filename_id_;       // filename from which the module was created
    size_t base_offset_ = 0;     // offset in the binary file
    CPU cpu_id_ = DEFAULT_CPU;
    bool swap_ixiy_ = false;
    uint base_address_ = OrgNotDefined;
    std::unique_ptr<ObjSchema> obj_schema_ = nullptr;
    std::unique_ptr<StringTable> strings_ = nullptr;
    std::unique_ptr<ObjModname> modname_ = nullptr;
    std::unique_ptr<std::vector<ObjExpr>> exprs_ = nullptr;
    std::unique_ptr<std::vector<ObjReloc>> relocs_ = nullptr;
    std::unique_ptr<std::vector<ObjSymbol>> symbols_ = nullptr;
    std::unique_ptr<std::vector<ObjExtern>> externs_ = nullptr;
    std::unique_ptr<std::vector<ObjSection>> sections_ = nullptr;
    std::unique_ptr<std::unordered_set<StringId>> public_symbols_ = nullptr;
};

//-----------------------------------------------------------------------------
// Library
//-----------------------------------------------------------------------------

// symbol index key
struct CpuKey {
    CPU cpu_id;
    bool swap_ixiy;

    CpuKey(CPU cpu_id_, bool swap_ixiy_) : cpu_id(cpu_id_), swap_ixiy(swap_ixiy_) {}

    bool operator==(const CpuKey& other) const {
        return cpu_id == other.cpu_id && swap_ixiy == other.swap_ixiy;
    }
};

// Hash function for CpuKey to enable use as unordered_map key
namespace std {
template <>
struct hash<CpuKey> {
    std::size_t operator()(const CpuKey& k) const noexcept {
        return (static_cast<size_t>(k.cpu_id) << 1) | static_cast<size_t>(k.swap_ixiy);
    }
};
}

class ObjLibrary {
public:
    StringId filename_id() const {
        return filename_id_;
    }
    void set_filename_id(StringId id) {
        filename_id_ = id;
    }
    std::string_view filename() const {
        return g_strings.view(filename_id_);
    }
    void set_filename(std::string_view filename) {
        filename_id_ = g_strings.intern(filename);
    }
    size_t base_offset() const {
        return base_offset_;
    }
    void set_base_offset(size_t offset) {
        base_offset_ = offset;
    }
    StringId read_string_id(size_t& ptr);

    // accessors load sections on demand, if not already loaded
    StringTable* strings();
    std::vector<ObjModule>* modules();
    std::unordered_map<CpuKey, std::unordered_map<StringId, size_t>>*
            symbol_index();

    // lookup public symbol in library, returns ObjModule defining it
    // for current CPU and swap_ixiy, or nullptr if not found
    // current CPU and swap_ixiy are copied from options anf stored in LibSchema
    // when the library is unpacked, and can be changed with set_cpu_id() and set_swap_ixiy()
    ObjModule* lookup_public_symbol(StringId sym_name_id);

#ifdef _DEBUG
    void dump_loaded_sections(DumpContext ctx);
    void dump(DumpContext ctx);
#endif
    void dump_short();

    void pack(BinaryData& bin_data);
    void unpack(std::shared_ptr<const BinaryFile> file);

private:
    StringId filename_id_;       // filename from which the module was created
    size_t base_offset_ = 0;     // offset in the binary file
    std::unique_ptr<LibSchema> lib_schema_ = nullptr;
    std::unique_ptr<StringTable> strings_ = nullptr;
    std::unique_ptr<std::vector<ObjModule>> modules_ = nullptr;
    std::unique_ptr<std::unordered_map<CpuKey, std::unordered_map<StringId, size_t>>>
    symbol_index_ = nullptr;
    std::unique_ptr<std::unordered_map<StringId, ObjModule*>> symbol_to_module_ =
                nullptr;

    void build_symbol_index(bool file_string_table);
    size_t pack_symbol_index(BinaryData& bin_data);
    void build_symbol_to_module_map_v19();
    void build_symbol_to_module_map_older();
};

//-----------------------------------------------------------------------------
// Interface for linker
//-----------------------------------------------------------------------------

class ObjFile {
public:
    explicit ObjFile(std::string_view filename);
    virtual ~ObjFile() = default;

    std::string_view filename() const {
        return schema_->filename();
    }
    ObjFileType type() const {
        return schema_->type;
    }
    int version() const {
        return schema_->version;
    }
    size_t num_modules() const;
    ObjModule* module(size_t index) const;
    ObjModule* lookup_public_symbol(StringId sym_name_id);

#ifdef _DEBUG
    void dump_loaded_sections(DumpContext ctx);
    void dump(DumpContext ctx);
#endif

private:
    std::shared_ptr<const BinaryFile> file_;
    std::unique_ptr<CommonSchema> schema_ = nullptr;

    // loads one of these, depending on file type
    std::unique_ptr<ObjModule> obj_module_ = nullptr;
    std::unique_ptr<std::unordered_set<StringId>> public_symbols_ = nullptr;

    std::unique_ptr<ObjLibrary> obj_library_ = nullptr;
};

//-----------------------------------------------------------------------------
// Drivers
//-----------------------------------------------------------------------------

void write_object_library(ObjLibrary& obj_lib, std::string_view filename);
void read_object_library(ObjLibrary& obj_lib, std::string_view filename);

#ifdef _DEBUG
[[noreturn]]
void dump_obj_lib_and_exit(ObjLibrary& obj_lib);
#endif
