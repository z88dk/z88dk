//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "diag.h"
#include "files.h"
#include "obj_file.h"
#include "options.h"
#include "release_assert.h"
#include "string_interner.h"
#include "string_utils.h"
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <string>
#include <string_view>
#include <vector>

static constexpr int END_FILE_MARKER = -1;

static std::string to_string(ObjExprRange range) {
    switch (range) {
    case ObjExprRange::Undefined:
        return "Undefined";
    case ObjExprRange::JrOffset:
        return "JrOffset";
    case ObjExprRange::ByteUnsigned:
        return "ByteUnsigned";
    case ObjExprRange::ByteSigned:
        return "ByteSigned";
    case ObjExprRange::Word:
        return "Word";
    case ObjExprRange::WordBE:
        return "WordBE";
    case ObjExprRange::DWord:
        return "DWord";
    case ObjExprRange::ByteToWordUnsigned:
        return "ByteToWordUnsigned";
    case ObjExprRange::ByteToWordSigned:
        return "ByteToWordSigned";
    case ObjExprRange::Ptr24:
        return "Ptr24";
    case ObjExprRange::HighOffset:
        return "HighOffset";
    case ObjExprRange::Assignment:
        return "Assignment";
    case ObjExprRange::JreOffset:
        return "JreOffset";
    case ObjExprRange::ByteToPtrUnsigned:
        return "ByteToPtrUnsigned";
    case ObjExprRange::ByteToPtrSigned:
        return "ByteToPtrSigned";
    default:
        release_assert(0);
        return "Unknown";
    }
}

static std::string to_string(ObjSymbolScope scope) {
    switch (scope) {
    case ObjSymbolScope::Undefined:
        return "Undefined";
    case ObjSymbolScope::Local:
        return "Local";
    case ObjSymbolScope::Public:
        return "Public";
    default:
        release_assert(0);
        return "Unknown";
    }
}

static std::string to_string(ObjSymbolType type) {
    switch (type) {
    case ObjSymbolType::Undefined:
        return "Undefined";
    case ObjSymbolType::Constant:
        return "Constant";
    case ObjSymbolType::AddressRelative:
        return "AddressRelative";
    case ObjSymbolType::Computed:
        return "Computed";
    default:
        release_assert(0);
        return "Unknown";
    }
}

// Helper to format a vector of bytes as a hex string
static std::string format_bytes(const std::vector<uint8_t>& bytes) {
    std::string result;
    for (size_t i = 0; i < bytes.size(); ++i) {
        if (i > 0) {
            result += " ";
        }
        result += int_to_hex(bytes[i]);
    }
    return result;
}

void ObjExpr::dump(DumpContext ctx) const {
    ctx.line("ObjExpr");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    c.line("Text: " + escape_string(g_strings.view(text_id)));
    c.line("Range: " + to_string(range));
    c.line("ASMPC: " + int_to_hex(asmpc));
    c.line("Code pos: " + int_to_hex(code_pos));
    c.line("Opcode size: " + int_to_hex(opcode_size));
    if (section_name_id != 0) {
        c.line("Section: " + g_strings.to_string(section_name_id));
    }
    if (target_name_id != 0) {
        c.line("Target: " + g_strings.to_string(target_name_id));
    }
}

void ObjSymbol::dump(DumpContext ctx) const {
    ctx.line("ObjSymbol: " + g_strings.to_string(name_id));
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    c.line("Scope: " + to_string(scope));
    c.line("Type: " + to_string(type));
    c.line("Value: " + int_to_hex(value));
    if (section_name_id != 0) {
        c.line("Section: " + g_strings.to_string(section_name_id));
    }
}

void ObjSection::dump(DumpContext ctx) const {
    std::string section_name = "ObjSection: ";
    if (name_id != 0) {
        section_name += g_strings.to_string(name_id);
    }
    else {
        section_name += "\"\"";
    }
    ctx.line(section_name);
    auto c = ctx.child();

    if (org_defined) {
        c.line("ORG: " + int_to_hex(base_address));
    }
    if (section_split) {
        c.line("Section split: true");
    }
    c.line("Align: " + int_to_hex(align));
    if (!bytes.empty()) {
        c.line("Bytes (" + std::to_string(bytes.size()) + "): " + format_bytes(bytes));
    }
}

void ObjectModule::dump(DumpContext ctx) const {
    ctx.line("ObjectModule: " + g_strings.to_string(module_name_id));
    auto c = ctx.child();
    c.line("CPU: " + to_string(cpu_id));
    if (swap_ix_iy) {
        c.line("Swap IX/IY: true");
    }

    if (!exprs.empty()) {
        c.line("Expressions:");
        auto ec = c.child();
        for (const auto& expr : exprs) {
            expr->dump(ec);
        }
    }

    if (!symbols.empty()) {
        c.line("Defined symbols:");
        auto sc = c.child();
        for (const auto& symbol : symbols) {
            symbol->dump(sc);
        }
    }

    if (!externs.empty()) {
        c.line("External symbols:");
        auto xc = c.child();
        for (const auto& ext_id : externs) {
            xc.line(g_strings.to_string(ext_id));
        }
    }

    if (!sections.empty()) {
        c.line("Sections:");
        auto sec_c = c.child();
        for (const auto& section : sections) {
            section->dump(sec_c);
        }
    }
}

void ObjectModule::clear() {
    cpu_id = CPU::z80;
    swap_ix_iy = false;
    exprs.clear();
    symbols.clear();
    externs.clear();
    sections.clear();
}

void ObjectLibrary::dump(DumpContext ctx) const {
    ctx.line("ObjectLibrary");
    auto c = ctx.child();

    if (!modules.empty()) {
        c.line("Modules (" + std::to_string(modules.size()) + "):");
        auto mc = c.child();
        for (const auto& module : modules) {
            module->dump(mc);
        }
    }

    if (!public_symbols.empty()) {
        c.line("Public symbols:");
        auto mc = c.child();
        for (auto& name_id : public_symbols) {
            mc.line(g_strings.view(name_id));
        }
    }
}

void ObjectLibrary::clear() {
    modules.clear();
    public_symbols.clear();
}

static void append_string(std::vector<uint8_t>& bytes, std::string_view str) {
    for (size_t i = 0; i < str.size(); i++) {
        bytes.push_back(static_cast<uint8_t>(str[i]));
    }
}

// little-endian 32-bit patch
static void patch_int32(std::vector<uint8_t>& bytes, size_t pos, int value) {
    release_assert(pos + 4 <= bytes.size());
    std::uint32_t u = static_cast<std::uint32_t>(value);
    for (size_t i = 0; i < 4; i++) {
        bytes[pos + i] = static_cast<uint8_t>( (u >> (8 * i)) & 0xFF);
    }
}

// little-endian 32-bit write
static void append_int32(std::vector<uint8_t>& bytes, int value) {
    size_t pos = bytes.size();
    bytes.resize(pos + 4);
    patch_int32(bytes, pos, value);
}

static bool read_string(const std::vector<uint8_t> bytes, size_t& pos,
                        size_t length,
                        std::string& out_string) {
    out_string.clear();
    if (pos + length > bytes.size()) {
        return false;   // malformed binary file
    }

    for (size_t i = 0; i < length; i++) {
        out_string.push_back(bytes[pos++]);
    }
    return true;
}

static bool read_int32(const std::vector<uint8_t> bytes, size_t& pos,
                       int32_t& out_value) {
    out_value = 0;
    if (pos + 4 > bytes.size()) {
        return false;   // malformed binary file
    }

    for (size_t i = 0; i < 4; i++) {
        out_value |= (bytes[pos++] & 0xFF) << (i * 8);
    }
    return true;
}

template<typename T>
bool read_int32(const std::vector<uint8_t> bytes, size_t& pos, T& out_value) {
    int32_t value = 0;
    if (!read_int32(bytes, pos, value)) {
        return false;
    }

    out_value = static_cast<T>(value);
    return true;
}

// read a string table
static bool read_string_table(const std::vector<uint8_t> bytes, size_t pos,
                              StringInterner& strings) {
    strings.clear();

    // read number of strings
    size_t num_strings = 0;
    if (!read_int32(bytes, pos, num_strings)) {
        return false;
    }

    // read size of blob with strings
    size_t blob_size = 0;
    if (!read_int32(bytes, pos, blob_size)) {
        return false;
    }

    // read start position of each string
    std::vector<size_t> start_pos;
    for (size_t i = 0; i < num_strings; i++) {
        size_t p = 0;
        if (!read_int32(bytes, pos, p)) {
            return false;
        }
        start_pos.push_back(p);
    }

    // read string blob
    std::string blob;
    if (!read_string(bytes, pos, blob_size, blob)) {
        return false;
    }

    // create each string in StringInterner
    for (size_t i = 0; i < num_strings; i++) {
        const char* str = blob.c_str() + start_pos[i];
        StringInterner::Id id = strings.intern(str);
        release_assert(id == i);
    }

    return true;
}

// append a string table
static void append_string_table(std::vector<uint8_t>& bytes,
                                const StringInterner& strings) {
    // header has number of strings and total size of blob with all strings
    size_t num_strings = strings.size();
    append_int32(bytes, static_cast<int>(num_strings));
    size_t strings_size_pos = bytes.size();
    append_int32(bytes, 0);

    // write index of each string into blob of strings concatenated separated by '\0'
    size_t str_table_pos = 0;
    for (size_t id = 0; id < num_strings; id++) {
        std::string_view str = strings.view(static_cast<StringInterner::Id>(id));
        size_t pos = str_table_pos;
        str_table_pos += str.size() + 1;        // chars + null char

        append_int32(bytes, static_cast<int>(pos));               // index into strings
    }

    // write all strings together
    for (size_t id = 0; id < num_strings; id++) {
        std::string_view str = strings.view(static_cast<StringInterner::Id>(id));
        append_string(bytes, str);              // string
        bytes.push_back(0);                     // null terminator
    }

    // align to 32-bit size
    while (bytes.size() % 4 != 0) {
        bytes.push_back(0);
        str_table_pos++;
    }

    // write the blob length (str_table_pos)
    patch_int32(bytes, strings_size_pos, static_cast<int>(str_table_pos));
}

static void pack_object_exprs(std::vector<uint8_t>& bytes,
                              StringInterner& strings,
                              const std::vector<std::unique_ptr<ObjExpr>>& exprs) {
    for (auto& expr : exprs) {
        append_int32(bytes, static_cast<int>(expr->range));
        append_int32(bytes, strings.intern(g_strings.view(expr->loc.file_id)));
        append_int32(bytes, expr->loc.line);
        append_int32(bytes, strings.intern(g_strings.view(expr->section_name_id)));
        append_int32(bytes, expr->asmpc);
        append_int32(bytes, expr->code_pos);
        append_int32(bytes, expr->opcode_size);
        append_int32(bytes, strings.intern(g_strings.view(expr->target_name_id)));
        append_int32(bytes, strings.intern(g_strings.view(expr->text_id)));
    }

    // end marker
    append_int32(bytes, 0);
}

static void pack_object_symbols(std::vector<uint8_t>& bytes,
                                StringInterner& strings,
                                const std::vector<std::unique_ptr<ObjSymbol>>& symbols) {
    for (auto& sym : symbols) {
        append_int32(bytes, static_cast<int>(sym->scope));
        append_int32(bytes, static_cast<int>(sym->type));
        append_int32(bytes, strings.intern(g_strings.view(sym->section_name_id)));
        append_int32(bytes, sym->value);
        append_int32(bytes, strings.intern(g_strings.view(sym->name_id)));
        append_int32(bytes, strings.intern(g_strings.view(sym->loc.file_id)));
        append_int32(bytes, sym->loc.line);
    }

    // end marker
    append_int32(bytes, 0);
}

static void pack_object_externs(std::vector<uint8_t>& bytes,
                                StringInterner& strings,
                                const std::vector<StringInterner::Id>& externs) {
    for (auto& sym : externs) {
        append_int32(bytes, strings.intern(g_strings.view(sym)));
    }

    // end marker
    append_int32(bytes, 0);
}

static void pack_object_modname(std::vector<uint8_t>& bytes,
                                StringInterner& strings,
                                std::string_view modname) {
    append_int32(bytes, strings.intern(modname));
}

static void pack_object_sections(std::vector<uint8_t>& bytes,
                                 StringInterner& strings,
                                 const std::vector<std::unique_ptr<ObjSection>>& sections) {
    for (auto& section : sections) {
        append_int32(bytes, static_cast<int>(section->bytes.size()));
        append_int32(bytes, strings.intern(g_strings.view(section->name_id)));

        if (!section->org_defined) {
            append_int32(bytes, ObjSection::OrgNotDefined);
        }
        else if (section->section_split) {
            append_int32(bytes, ObjSection::OrgSectionSplit);
        }
        else {
            append_int32(bytes, section->base_address);
        }

        append_int32(bytes, section->align);

        // append the binary data
        for (auto c : section->bytes) {
            bytes.push_back(c);
        }

        // align
        while (bytes.size() % 4 != 0) {
            bytes.push_back(0);
        }
    }

    // end marker
    append_int32(bytes, END_FILE_MARKER);
}

static void pack_object_module(std::vector<uint8_t>& bytes,
                               const ObjectModule& obj_mod) {
    StringInterner strings;

    // mark the start for the relative pointers
    size_t base = bytes.size();

    // add signature
    append_string(bytes, OBJ_FILE_SIGNATURE);

    // add CPU and IXIY
    append_int32(bytes, static_cast<int>(g_args.options.cpu_id));
    append_int32(bytes, static_cast<int>(g_args.options.swap_ix_iy));

    // append placeholders for 6 pointers to file sections
    size_t header_ptr = bytes.size();
    for (int i = 0; i < 6; i++) {
        append_int32(bytes, END_FILE_MARKER);
    }

    // write each of the sections and collect the addresses
    size_t expr_ptr = bytes.size();
    pack_object_exprs(bytes, strings, obj_mod.exprs);
    size_t symbols_ptr = bytes.size();
    pack_object_symbols(bytes, strings, obj_mod.symbols);
    size_t externs_ptr = bytes.size();
    pack_object_externs(bytes, strings, obj_mod.externs);
    size_t modname_ptr = bytes.size();
    pack_object_modname(bytes, strings,
                        g_strings.view(obj_mod.module_name_id));
    size_t sections_ptr = bytes.size();
    pack_object_sections(bytes, strings, obj_mod.sections);
    size_t st_ptr = bytes.size();
    append_string_table(bytes, strings);

    // write pointers to areas
    patch_int32(bytes, header_ptr + 0 * 4, static_cast<int>(modname_ptr  - base));
    patch_int32(bytes, header_ptr + 1 * 4, static_cast<int>(expr_ptr     - base));
    patch_int32(bytes, header_ptr + 2 * 4, static_cast<int>(symbols_ptr  - base));
    patch_int32(bytes, header_ptr + 3 * 4, static_cast<int>(externs_ptr  - base));
    patch_int32(bytes, header_ptr + 4 * 4, static_cast<int>(sections_ptr - base));
    patch_int32(bytes, header_ptr + 5 * 4, static_cast<int>(st_ptr       - base));
}

static void pack_object_library(std::vector<uint8_t>& bytes,
                                const ObjectLibrary& obj_lib) {
    // add signature
    append_string(bytes, LIB_FILE_SIGNATURE);

    // add string table pointer placeholder
    size_t st_table_ptr = bytes.size();
    append_int32(bytes, END_FILE_MARKER);   // string table pointer

    // add each module
    size_t prev_ptr = 0;
    for (auto& obj_mod : obj_lib.modules) {
        // append header
        prev_ptr = bytes.size();
        append_int32(bytes, END_FILE_MARKER);   // next module
        size_t len_ptr = bytes.size();
        append_int32(bytes, 0);     // length of this module

        // append module
        size_t mod_pos = bytes.size();
        pack_object_module(bytes, *obj_mod);
        size_t next_ptr = bytes.size();
        size_t mod_size = next_ptr - mod_pos;

        // patch values
        patch_int32(bytes, prev_ptr, static_cast<int>(next_ptr));     // next module
        patch_int32(bytes, len_ptr,
                    static_cast<int>(mod_size));      // length of this module
    }

    // mark the end of the chain
    if (prev_ptr != 0) {        // any module written
        patch_int32(bytes, prev_ptr, END_FILE_MARKER);
    }

    // patch the string pointer
    size_t st_pos = bytes.size();
    patch_int32(bytes, st_table_ptr, static_cast<int>(st_pos));

    // write the string table
    StringInterner ps_st;
    for (auto name_id : obj_lib.public_symbols) {
        ps_st.intern(g_strings.view(name_id));
    }
    append_string_table(bytes, ps_st);
}

bool write_object_library(const ObjectLibrary& obj_lib,
                          std::string_view filename) {
    if (g_args.options.verbose) {
        std::cout << "Writing object file: " << filename << std::endl;
    }

    // pack
    std::vector<uint8_t> bytes;
    pack_object_library(bytes, obj_lib);

    // write file
    std::string filename_s(filename);
    if (!write_binary_file(filename, bytes)) {
        g_diag.error(SourceLoc(), "Cannot create file: " + filename_s);
        return false;
    }

    return true;
}

static bool unpack_object_exprs(const std::vector<uint8_t> bytes,
                                size_t base_pos,
                                ObjectModule& obj_mod,
                                StringInterner& strings) {
    size_t pos = base_pos;

    while (true) {
        auto expr = std::make_unique<ObjExpr>();

        expr->range = ObjExprRange::Undefined;
        if (!read_int32(bytes, pos, expr->range)) {
            return false;
        }

        if (expr->range == ObjExprRange::Undefined) {
            break;      // end of expressions
        }

        StringInterner::Id file_id = 0;
        if (!read_int32(bytes, pos, file_id)) {
            return false;
        }
        expr->loc.file_id = static_cast<uint16_t>(g_strings.intern(strings.view(
                                file_id)));

        if (!read_int32(bytes, pos, expr->loc.line)) {
            return false;
        }

        StringInterner::Id section_name_id = 0;
        if (!read_int32(bytes, pos, section_name_id)) {
            return false;
        }
        expr->section_name_id = g_strings.intern(strings.view(section_name_id));

        if (!read_int32(bytes, pos, expr->asmpc)) {
            return false;
        }

        if (!read_int32(bytes, pos, expr->code_pos)) {
            return false;
        }

        if (!read_int32(bytes, pos, expr->opcode_size)) {
            return false;
        }

        StringInterner::Id target_name_id = 0;
        if (!read_int32(bytes, pos, target_name_id)) {
            return false;
        }
        expr->target_name_id = g_strings.intern(strings.view(target_name_id));

        StringInterner::Id text_id = 0;
        if (!read_int32(bytes, pos, text_id)) {
            return false;
        }
        expr->text_id = g_strings.intern(strings.view(text_id));

        obj_mod.exprs.push_back(std::move(expr));
    }

    return true;
}

static bool unpack_object_symbols(const std::vector<uint8_t> bytes,
                                  size_t base_pos,
                                  ObjectModule& obj_mod,
                                  StringInterner& strings) {
    size_t pos = base_pos;

    while (true) {
        auto sym = std::make_unique<ObjSymbol>();

        sym->scope = ObjSymbolScope::Undefined;
        if (!read_int32(bytes, pos, sym->scope)) {
            return false;
        }

        if (sym->scope == ObjSymbolScope::Undefined) {
            break;      // end of symbols
        }

        sym->type = ObjSymbolType::Undefined;
        if (!read_int32(bytes, pos, sym->type)) {
            return false;
        }

        StringInterner::Id section_name_id = 0;
        if (!read_int32(bytes, pos, section_name_id)) {
            return false;
        }
        sym->section_name_id = g_strings.intern(strings.view(section_name_id));

        if (!read_int32(bytes, pos, sym->value)) {
            return false;
        }

        StringInterner::Id name_id = 0;
        if (!read_int32(bytes, pos, name_id)) {
            return false;
        }
        sym->name_id = g_strings.intern(strings.view(name_id));

        StringInterner::Id file_id = 0;
        if (!read_int32(bytes, pos, file_id)) {
            return false;
        }
        sym->loc.file_id = static_cast<uint16_t>(g_strings.intern(strings.view(
                               file_id)));

        if (!read_int32(bytes, pos, sym->loc.line)) {
            return false;
        }

        obj_mod.symbols.push_back(std::move(sym));
    }
    return true;
}

static bool unpack_object_externs(const std::vector<uint8_t> bytes,
                                  size_t base_pos,
                                  ObjectModule& obj_mod,
                                  StringInterner& strings) {
    size_t pos = base_pos;

    while (true) {
        StringInterner::Id name_id = 0;

        if (!read_int32(bytes, pos, name_id)) {
            return false;
        }

        if (name_id == 0) {
            break;      // end of externs
        }

        obj_mod.externs.push_back(g_strings.intern(strings.view(name_id)));
    }

    return true;
}

static bool unpack_object_sections(const std::vector<uint8_t> bytes,
                                   size_t base_pos,
                                   ObjectModule& obj_mod,
                                   StringInterner& strings) {
    size_t pos = base_pos;

    while (true) {
        auto section = std::make_unique<ObjSection>();

        int section_size = 0;
        if (!read_int32(bytes, pos, section_size)) {
            return false;
        }

        if (section_size == END_FILE_MARKER) {
            break;      // end of sections
        }

        StringInterner::Id name_id = 0;
        if (!read_int32(bytes, pos, name_id)) {
            return false;
        }
        section->name_id = g_strings.intern(strings.view(name_id));

        int org_value = 0;
        if (!read_int32(bytes, pos, org_value)) {
            return false;
        }

        if (org_value == ObjSection::OrgNotDefined) {
            section->org_defined = false;
            section->section_split = false;
            section->base_address = 0;
        }
        else if (org_value == ObjSection::OrgSectionSplit) {
            section->org_defined = false;
            section->section_split = true;
            section->base_address = 0;
        }
        else {
            section->org_defined = true;
            section->section_split = false;
            section->base_address = static_cast<uint>(org_value);
        }

        if (!read_int32(bytes, pos, section->align)) {
            return false;
        }

        // read the binary data
        section->bytes.reserve(section_size);
        for (int i = 0; i < section_size; i++) {
            uint8_t c = 0;
            if (!read_int32(bytes, pos, c)) {
                return false;
            }
            section->bytes.push_back(c);
        }

        // align to 4 bytes
        while (pos % 4 != 0) {
            uint8_t c = 0;
            if (!read_int32(bytes, pos, c)) {
                return false;
            }
            release_assert(c == 0);
        }

        obj_mod.sections.push_back(std::move(section));
    }

    return true;
}

static bool unpack_object_module(const std::vector<uint8_t> bytes,
                                 size_t base_pos,
                                 ObjectModule& obj_mod) {
    size_t pos = base_pos + OBJ_FILE_SIGNATURE.size();  // signature already read

    // read CPU and swap IX/IY
    obj_mod.cpu_id = DEFAULT_CPU;
    if (!read_int32(bytes, pos, obj_mod.cpu_id)) {
        return false;
    }

    obj_mod.swap_ix_iy = false;
    if (!read_int32(bytes, pos, obj_mod.swap_ix_iy)) {
        return false;
    }

    // read 6 file pointers
    size_t modname_pos = 0;
    if (!read_int32(bytes, pos, modname_pos)) {
        return false;
    }

    size_t expr_pos = 0;
    if (!read_int32(bytes, pos, expr_pos)) {
        return false;
    }

    size_t symbols_pos = 0;
    if (!read_int32(bytes, pos, symbols_pos)) {
        return false;
    }

    size_t externs_pos = 0;
    if (!read_int32(bytes, pos, externs_pos)) {
        return false;
    }

    size_t sections_pos = 0;
    if (!read_int32(bytes, pos, sections_pos)) {
        return false;
    }

    size_t string_table_pos = 0;
    if (!read_int32(bytes, pos, string_table_pos)) {
        return false;
    }

    // read string table
    StringInterner strings;
    pos = base_pos + string_table_pos;
    if (!read_string_table(bytes, pos, strings)) {
        return false;
    }

    // read module name
    pos = base_pos + modname_pos;
    StringInterner::Id modname_id = 0;
    if (!read_int32(bytes, pos, modname_id)) {
        return false;
    }
    obj_mod.module_name_id = g_strings.intern(strings.view(modname_id));

    // read expressions
    pos = base_pos + expr_pos;
    if (!unpack_object_exprs(bytes, pos, obj_mod, strings)) {
        return false;
    }

    // read symbols
    pos = base_pos + symbols_pos;
    if (!unpack_object_symbols(bytes, pos, obj_mod, strings)) {
        return false;
    }

    // read externs
    pos = base_pos + externs_pos;
    if (!unpack_object_externs(bytes, pos, obj_mod, strings)) {
        return false;
    }

    // read sections
    pos = base_pos + sections_pos;
    if (!unpack_object_sections(bytes, pos, obj_mod, strings)) {
        return false;
    }

    return true;
}

static bool unpack_object_library(const std::vector<uint8_t> bytes,
                                  size_t base_pos,
                                  ObjectLibrary& obj_lib) {
    size_t pos = base_pos;

    // read signature
    std::string signature;
    if (!read_string(bytes, pos, OBJ_FILE_SIGNATURE.size(), signature)) {
        return false; // file too short
    }

    // check signature
    if (signature == OBJ_FILE_SIGNATURE) {
        // create a new module and unpack it
        auto module = std::make_unique<ObjectModule>();
        if (!unpack_object_module(bytes, base_pos, *module)) {
            return false;
        }
        obj_lib.modules.push_back(std::move(module));
    }
    else if (signature == LIB_FILE_SIGNATURE) {
        // read string table with public symbols
        size_t string_table_pos = 0;
        if (!read_int32(bytes, pos, string_table_pos)) {
            return false;
        }

        StringInterner public_symbols;
        if (!read_string_table(bytes, string_table_pos, public_symbols)) {
            return false;
        }

        for (size_t i = 0; i < public_symbols.size(); i++) {
            std::string_view symbol = public_symbols.view(
                                          static_cast<StringInterner::Id>(i));
            obj_lib.public_symbols.insert(g_strings.intern(symbol));
        }

        // read all the modules
        // pos is just after the string table pointer
        while (true) {
            size_t next_module_pos = 0;
            if (!read_int32(bytes, pos, next_module_pos)) {
                return false;
            }

            size_t module_size = 0;
            if (!read_int32(bytes, pos, module_size)) {
                return false;
            }

            if (module_size > 0) {  // not "deleted"
                // create a new module and unpack it
                auto module = std::make_unique<ObjectModule>();
                if (!unpack_object_module(bytes, pos, *module)) {
                    return false;
                }
                obj_lib.modules.push_back(std::move(module));
            }

            if (next_module_pos == (size_t) -1) {
                break;
            }

            // prepare to read next module
            pos = next_module_pos;
        }
    }
    else {
        return false; // invalid signature
    }

    return true;
}

bool read_object_library(ObjectLibrary& obj_lib,
                         std::string_view filename) {
    obj_lib.clear();

    // read file
    std::vector<uint8_t> bytes;
    if (!read_binary_file(filename, bytes)) {
        g_diag.error(SourceLoc(), "Failed to read file: " + std::string(filename));
        return false;
    }

    // unpack binary data
    if (!unpack_object_library(bytes, 0, obj_lib)) {
        g_diag.error(SourceLoc(),
                     "Invalid object/library file: " + std::string(filename));
        return false;
    }

    return true;
}

void dump_obj_lib_and_exit(const ObjectLibrary& obj_lib) {
    DumpContext ctx(std::cout);
    obj_lib.dump(ctx);
    std::exit(EXIT_SUCCESS);
}
