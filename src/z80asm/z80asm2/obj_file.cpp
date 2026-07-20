//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "binary_data.h"
#include "cpu.h"
#include "diag.h"
#include "files.h"
#include "obj_expr.h"
#include "obj_file.h"
#include "obj_reloc.h"
#include "options.h"
#include "release_assert.h"
#include "source_loc.h"
#include "strings.h"
#include "string_utils.h"
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <string>
#include <string_view>
#include <vector>
#include "obj_symbol_scope.h"
#include "obj_symbol_type.h"

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

void ObjSection::dump(DumpContext ctx) const {
    std::string section_name = "ObjSection: ";
    if (name_id != 0) {
        section_name += g_strings.string(name_id);
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
    ctx.line("ObjectModule: " + g_strings.string(module_name_id));
    auto c = ctx.child();
    c.line("CPU: " + to_string(cpu_id));
    if (swap_ix_iy) {
        c.line("Swap IX/IY: true");
    }

    ObjExpr::dump_exprs(c, exprs);

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
            xc.line(g_strings.string(ext_id));
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
                              Strings& strings) {
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

    // create each string in Strings
    for (size_t i = 0; i < num_strings; i++) {
        const char* str = blob.c_str() + start_pos[i];
        uint id = strings.intern(str);
        release_assert(id == i);
    }

    return true;
}

static size_t pack_object_externs(BinaryData& bytes,
                                  Strings& strings,
                                  const std::vector<uint>& externs) {
    if (externs.empty()) {
        return OffsetNotPresent;
    }

    size_t start_offset = bytes.size();
    for (auto& sym : externs) {
        bytes.put_dword(static_cast<uint32_t>(strings.intern(g_strings.view(sym))));
    }

    // end marker
    bytes.put_dword(0);

    return start_offset;
}

static size_t pack_object_modname(BinaryData& bytes,
                                  Strings& strings,
                                  std::string_view modname) {
    size_t start_offset = bytes.size();
    bytes.put_dword(static_cast<uint32_t>(strings.intern(modname)));
    return start_offset;
}

static size_t pack_object_sections(BinaryData& bytes,
                                   Strings& strings,
                                   const std::vector<std::unique_ptr<ObjSection>>& sections) {
    if (sections.empty()) {
        return OffsetNotPresent;
    }

    size_t start_offset = bytes.size();
    for (auto& section : sections) {
        bytes.put_dword(static_cast<uint32_t>(section->bytes.size()));
        bytes.put_dword(static_cast<uint32_t>(strings.intern(g_strings.view(
                section->name_id))));

        if (!section->org_defined) {
            bytes.put_dword(static_cast<uint32_t>(ObjSection::OrgNotDefined));
        }
        else if (section->section_split) {
            bytes.put_dword(static_cast<uint32_t>(ObjSection::OrgSectionSplit));
        }
        else {
            bytes.put_dword(static_cast<uint32_t>(section->base_address));
        }

        bytes.put_dword(static_cast<uint32_t>(section->align));

        // append the binary data
        bytes.put_data(section->bytes.data(), section->bytes.size());

        // align
        bytes.align(4);
    }

    // end marker
    bytes.put_dword(OffsetNotPresent);

    return start_offset;
}

static void pack_object_module(BinaryData& bytes,
                               const ObjectModule& obj_mod) {
    Strings strings;

    // mark the start for the relative pointers
    size_t base = bytes.size();

    // add signature
    bytes.put_string(obj_file_signature());

    // add CPU and IXIY
    bytes.put_dword(static_cast<uint32_t>(g_args.options.cpu_id));
    bytes.put_dword(static_cast<uint32_t>(g_args.options.swap_ix_iy));

    // append placeholders for 6 pointers to file sections
    size_t header_ptr = bytes.size();
    for (int i = 0; i < 7; i++) {
        bytes.put_dword(OffsetNotPresent);
    }

    // write each of the sections and collect the addresses
    size_t expr_ptr = ObjExpr::pack_exprs(bytes, strings, obj_mod.exprs);
    size_t relocs_ptr = ObjReloc::pack_relocs(bytes, strings, obj_mod.relocs);
    size_t symbols_ptr = ObjSymbol::pack_symbols(bytes, strings, obj_mod.symbols);
    size_t externs_ptr = pack_object_externs(bytes, strings, obj_mod.externs);
    size_t modname_ptr = pack_object_modname(bytes, strings,
                         g_strings.view(obj_mod.module_name_id));
    size_t sections_ptr = pack_object_sections(bytes, strings, obj_mod.sections);
    size_t st_ptr = bytes.size();
    strings.pack(bytes);

    // write pointers to areas
    auto calc_offset = [](size_t offset, size_t base) -> size_t {
        if (offset == OffsetNotPresent) {
            return offset;
        }
        else {
            return offset - base;
        }
    };
    size_t ptr = header_ptr;
    bytes.put_dword_at(ptr, static_cast<uint32_t>(calc_offset(modname_ptr,  base)));
    bytes.put_dword_at(ptr, static_cast<uint32_t>(calc_offset(expr_ptr,     base)));
    bytes.put_dword_at(ptr, static_cast<uint32_t>(calc_offset(relocs_ptr,   base)));
    bytes.put_dword_at(ptr, static_cast<uint32_t>(calc_offset(symbols_ptr,  base)));
    bytes.put_dword_at(ptr, static_cast<uint32_t>(calc_offset(externs_ptr,  base)));
    bytes.put_dword_at(ptr, static_cast<uint32_t>(calc_offset(sections_ptr, base)));
    bytes.put_dword_at(ptr, static_cast<uint32_t>(calc_offset(st_ptr,       base)));
}

static void pack_object_library(BinaryData& bytes,
                                const ObjectLibrary& obj_lib) {
    // add signature
    bytes.put_string(lib_file_signature());

    // add symbol index placeholder
    //size_t symbol_index_ptr = bytes.size();
    bytes.put_dword(OffsetNotPresent);   // symbol index pointer

    // add string table pointer placeholder
    size_t string_table_ptr = bytes.size();
    bytes.put_dword(OffsetNotPresent);   // string table pointer

    // add each module
    size_t prev_ptr = 0;
    for (auto& obj_mod : obj_lib.modules) {
        // append header
        prev_ptr = bytes.size();
        bytes.put_dword(OffsetNotPresent);   // next module
        size_t len_ptr = bytes.size();
        bytes.put_dword(0);     // length of this module

        // append module
        size_t mod_pos = bytes.size();
        pack_object_module(bytes, *obj_mod);
        size_t next_ptr = bytes.size();
        size_t mod_size = next_ptr - mod_pos;

        // patch values
        bytes.patch_dword(prev_ptr, static_cast<uint32_t>(next_ptr));     // next module
        bytes.patch_dword(len_ptr,
                          static_cast<uint32_t>(mod_size));      // length of this module
    }

    // mark the end of the chain
    if (prev_ptr != 0) {        // any module written
        bytes.patch_dword(prev_ptr, OffsetNotPresent);   // next module
    }

    // patch the string pointer
    size_t string_table_offset = bytes.size();
    bytes.patch_dword(string_table_ptr, static_cast<uint32_t>(string_table_offset));

    // write the string table
    Strings public_symbols;
    for (auto name_id : obj_lib.public_symbols) {
        public_symbols.intern(g_strings.view(name_id));
    }
    public_symbols.pack(bytes);
}

bool write_object_library(const ObjectLibrary& obj_lib,
                          std::string_view filename) {
    if (g_args.options.verbose) {
        std::cout << "Writing object file: " << filename << std::endl;
    }

    // pack
    BinaryData bytes;
    pack_object_library(bytes, obj_lib);

    // write file
    std::string filename_s(filename);
    if (!write_binary_file(filename, bytes.bytes)) {
        g_diag.error(SourceLoc(), "Cannot create file: " + filename_s);
        return false;
    }

    return true;
}

static bool unpack_object_exprs(const std::vector<uint8_t> bytes,
                                size_t base_pos,
                                ObjectModule& obj_mod,
                                Strings& strings) {
    size_t pos = base_pos;

    while (true) {
        auto expr = std::make_unique<ObjExpr>();

        expr->range = ObjRangeType::Undefined;
        if (!read_int32(bytes, pos, expr->range)) {
            return false;
        }

        if (expr->range == ObjRangeType::Undefined) {
            break;      // end of expressions
        }

        // read location
        uint file_id = 0;
        if (!read_int32(bytes, pos, file_id)) {
            return false;
        }
        std::string_view file_name = strings.view(file_id);

        uint line = 0;
        if (!read_int32(bytes, pos, line)) {
            return false;
        }

        expr->set_file(file_name);
        expr->line = line;

        // read section name
        uint section_name_id = 0;
        if (!read_int32(bytes, pos, section_name_id)) {
            return false;
        }
        std::string_view section_name = strings.view(section_name_id);
        expr->set_section_name(section_name);

        // read asmpc, patch_ptr, opcode_size
        if (!read_int32(bytes, pos, expr->asmpc)) {
            return false;
        }

        if (!read_int32(bytes, pos, expr->patch_ptr)) {
            return false;
        }

        if (!read_int32(bytes, pos, expr->opcode_size)) {
            return false;
        }

        // read target name and text
        uint target_name_id = 0;
        if (!read_int32(bytes, pos, target_name_id)) {
            return false;
        }
        std::string_view target_name = strings.view(target_name_id);
        expr->set_target_name(target_name);

        uint text_id = 0;
        if (!read_int32(bytes, pos, text_id)) {
            return false;
        }
        std::string_view text = strings.view(text_id);
        expr->set_text(text);

        obj_mod.exprs.push_back(std::move(expr));
    }

    return true;
}

static bool unpack_object_symbols(const std::vector<uint8_t> bytes,
                                  size_t base_pos,
                                  ObjectModule& obj_mod,
                                  Strings& strings) {
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

        uint section_name_id = 0;
        if (!read_int32(bytes, pos, section_name_id)) {
            return false;
        }
        sym->set_section_name(strings.view(section_name_id));

        if (!read_int32(bytes, pos, sym->value)) {
            return false;
        }

        uint name_id = 0;
        if (!read_int32(bytes, pos, name_id)) {
            return false;
        }
        sym->set_name(strings.view(name_id));

        uint file_id = 0;
        if (!read_int32(bytes, pos, file_id)) {
            return false;
        }
        sym->set_file(strings.view(file_id));

        if (!read_int32(bytes, pos, sym->line)) {
            return false;
        }

        obj_mod.symbols.push_back(std::move(sym));
    }
    return true;
}

static bool unpack_object_externs(const std::vector<uint8_t> bytes,
                                  size_t base_pos,
                                  ObjectModule& obj_mod,
                                  Strings& strings) {
    size_t pos = base_pos;

    while (true) {
        uint name_id = 0;

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
                                   Strings& strings) {
    size_t pos = base_pos;

    while (true) {
        auto section = std::make_unique<ObjSection>();

        size_t section_size = 0;
        if (!read_int32(bytes, pos, section_size)) {
            return false;
        }

        if (section_size == OffsetNotPresent) {
            break;      // end of sections
        }

        uint name_id = 0;
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
        for (size_t i = 0; i < section_size; i++) {
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
    size_t pos = base_pos + SignatureSize;  // signature already read

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
    Strings strings;
    pos = base_pos + string_table_pos;
    if (!read_string_table(bytes, pos, strings)) {
        return false;
    }

    // read module name
    pos = base_pos + modname_pos;
    uint modname_id = 0;
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
    if (!read_string(bytes, pos, SignatureSize, signature)) {
        return false; // file too short
    }

    // check signature
    if (signature == obj_file_signature()) {
        // create a new module and unpack it
        auto module = std::make_unique<ObjectModule>();
        if (!unpack_object_module(bytes, base_pos, *module)) {
            return false;
        }
        obj_lib.modules.push_back(std::move(module));
    }
    else if (signature == lib_file_signature()) {
        // read string table with public symbols
        size_t string_table_pos = 0;
        if (!read_int32(bytes, pos, string_table_pos)) {
            return false;
        }

        Strings public_symbols;
        if (!read_string_table(bytes, string_table_pos, public_symbols)) {
            return false;
        }

        for (size_t i = 0; i < public_symbols.size(); i++) {
            std::string_view symbol = public_symbols.view(
                                          static_cast<uint>(i));
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
