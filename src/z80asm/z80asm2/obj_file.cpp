//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "diag.h"
#include "obj_file.h"
#include "options.h"
#include "pathnames.h"
#include "release_assert.h"
#include "string_interner.h"
#include "string_utils.h"
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <string_view>

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
            expr.dump(ec);
        }
    }

    if (!symbols.empty()) {
        c.line("Defined symbols:");
        auto sc = c.child();
        for (const auto& symbol : symbols) {
            symbol.dump(sc);
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
            section.dump(sec_c);
        }
    }
}

void ObjectLibrary::dump(DumpContext ctx) const {
    ctx.line("ObjectLibrary");
    auto c = ctx.child();

    if (!modules.empty()) {
        c.line("Modules (" + std::to_string(modules.size()) + "):");
        auto mc = c.child();
        for (const auto& module : modules) {
            module.dump(mc);
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

static void serialize_object_exprs(std::vector<uint8_t>& bytes,
                                   StringInterner& strings,
                                   const std::vector<ObjExpr>& exprs) {
    for (auto& expr : exprs) {
        append_int32(bytes, static_cast<int>(expr.range));
        append_int32(bytes, strings.intern(g_strings.view(expr.loc.file_id)));
        append_int32(bytes, expr.loc.line);
        append_int32(bytes, strings.intern(g_strings.view(expr.section_name_id)));
        append_int32(bytes, expr.asmpc);
        append_int32(bytes, expr.code_pos);
        append_int32(bytes, expr.opcode_size);
        append_int32(bytes, strings.intern(g_strings.view(expr.target_name_id)));
        append_int32(bytes, strings.intern(g_strings.view(expr.text_id)));
    }

    // end marker
    append_int32(bytes, 0);
}

static void serialize_object_symbols(std::vector<uint8_t>& bytes,
                                     StringInterner& strings,
                                     const std::vector<ObjSymbol>& symbols) {
    for (auto& sym : symbols) {
        append_int32(bytes, static_cast<int>(sym.scope));
        append_int32(bytes, static_cast<int>(sym.type));
        append_int32(bytes, strings.intern(g_strings.view(sym.section_name_id)));
        append_int32(bytes, sym.value);
        append_int32(bytes, strings.intern(g_strings.view(sym.name_id)));
        append_int32(bytes, strings.intern(g_strings.view(sym.loc.file_id)));
        append_int32(bytes, sym.loc.line);
    }

    // end marker
    append_int32(bytes, 0);
}

static void serialize_object_externs(std::vector<uint8_t>& bytes,
                                     StringInterner& strings,
                                     const std::vector<StringInterner::Id>& externs) {
    for (auto& sym : externs) {
        append_int32(bytes, strings.intern(g_strings.view(sym)));
    }

    // end marker
    append_int32(bytes, 0);
}

static void serialize_object_modname(std::vector<uint8_t>& bytes,
                                     StringInterner& strings,
                                     std::string_view modname) {
    append_int32(bytes, strings.intern(modname));
}

static void serialize_object_sections(std::vector<uint8_t>& bytes,
                                      StringInterner& strings,
                                      const std::vector<ObjSection>& sections) {
    for (auto& section : sections) {
        append_int32(bytes, static_cast<int>(section.bytes.size()));
        append_int32(bytes, strings.intern(g_strings.view(section.name_id)));

        if (!section.org_defined) {
            append_int32(bytes, ObjSection::OrgNotDefined);
        }
        else if (section.section_split) {
            append_int32(bytes, ObjSection::OrgSectionSplit);
        }
        else {
            append_int32(bytes, section.base_address);
        }

        append_int32(bytes, section.align);

        // append the binary data
        for (auto c : section.bytes) {
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

static void serialize_object_module(std::vector<uint8_t>& bytes,
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
    serialize_object_exprs(bytes, strings, obj_mod.exprs);
    size_t symbols_ptr = bytes.size();
    serialize_object_symbols(bytes, strings, obj_mod.symbols);
    size_t externs_ptr = bytes.size();
    serialize_object_externs(bytes, strings, obj_mod.externs);
    size_t modname_ptr = bytes.size();
    serialize_object_modname(bytes, strings,
                             g_strings.view(obj_mod.module_name_id));
    size_t sections_ptr = bytes.size();
    serialize_object_sections(bytes, strings, obj_mod.sections);
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

static void serialize_object_library(std::vector<uint8_t>& bytes,
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
        serialize_object_module(bytes, obj_mod);
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

    // serialize
    std::vector<uint8_t> bytes;
    serialize_object_library(bytes, obj_lib);

    // write file
    std::string filename_s(filename);
    if (!write_binary_file(filename, bytes)) {
        g_diag.error(SourceLoc(), "Cannot create file: " + filename_s);
        return false;
    }

    return true;
}

void dump_obj_lib_and_exit(const ObjectLibrary& obj_lib) {
    DumpContext ctx(std::cout);
    obj_lib.dump(ctx);
    std::exit(EXIT_SUCCESS);
}
