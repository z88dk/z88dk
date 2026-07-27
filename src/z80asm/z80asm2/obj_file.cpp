//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "binary_data.h"
#include "binary_file.h"
#include "cpu.h"
#include "diag.h"
#include "dump_context.h"
#include "files.h"
#include "obj_features.h"
#include "obj_file.h"
#include "obj_range_type.h"
#include "obj_symbol_scope.h"
#include "obj_symbol_type.h"
#include "options.h"
#include "release_assert.h"
#include "source_loc.h"
#include "string_utils.h"
#include "strings.h"
#include <algorithm>
#include <charconv>
#include <cstdint>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <memory>
#include <sstream>
#include <string>
#include <string_view>
#include <system_error>
#include <unordered_map>
#include <utility>
#include <vector>

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

CommonSchema::CommonSchema(std::shared_ptr<const BinaryFile> file_,
                           size_t base_offset_, size_t size_)
    : file(std::move(file_)), base_offset(base_offset_), size(size_),
      cur_cpu_id(g_args.options.cpu_id),
      cur_swap_ixiy(g_args.options.swap_ixiy) {

    // check size
    if (end_offset() >= file->size()) {
        invalid_file_error("invalid object or library file");
    }

    // get signature, type and version
    std::string_view signature = file->peek_string_view(base_offset,
                                 SignatureSize);
    type = ObjFileType::None;
    if (!parse_signature(signature, type, version) ||
            type == ObjFileType::None) {
        invalid_file_error("invalid object or library file");
    }
}

[[noreturn]]
void CommonSchema::invalid_file_error(std::string_view message) const {
    fatal_error(std::string(message) + " in '" +
                std::string(file->filename()) +
                "' offset " + int_to_hex(base_offset));
}

SectionInfo CommonSchema::load_offset(size_t& ptr,
                                      std::string_view pointer_name) const {
    size_t offset = file->get_dword(ptr);
    if (offset == OffsetNotPresent) {
        return SectionInfo();
    }
    else {
        size_t start_offset = base_offset + offset;
        if (start_offset > base_offset + size) {
            invalid_file_error("invalid " + std::string(pointer_name) +
                               " pointer");
        }
        return SectionInfo(start_offset);
    }
}

//-----------------------------------------------------------------------------

ObjSchema::ObjSchema(std::shared_ptr<const BinaryFile> file_,
                     size_t base_offset_, size_t size_)
    : CommonSchema(file_, base_offset_, size_) {

    if (type != ObjFileType::Object) {
        invalid_file_error("invalid object file");
    }

    size_t ptr = offset_after_signature();

    // get CPU
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
    modname = load_offset(ptr, "module name");
    if (!modname.present) {
        invalid_file_error("missing module name pointer");
    }

    // expressions pointer
    exprs = load_offset(ptr, "expressions");

    // relocations pointer
    if (obj_features(version).has_relocs) {
        relocs = load_offset(ptr, "relocs");
    }
    else {
        relocs = SectionInfo();
    }

    // defined symbols pointer
    symbols = load_offset(ptr, "defined symbols");

    // extern symbols pointer
    externs = load_offset(ptr, "extern symbols");

    // sections pointer
    sections = load_offset(ptr, "sections");

    // string table pointer
    if (obj_features(version).has_string_table) {
        strings = load_offset(ptr, "string table");
    }
    else {
        strings = SectionInfo();
    }

    // compute sizes of sections
    if (exprs.present) {
        size_t next_offset = std::min({
            calc_end_offset(relocs, end_offset()),
            calc_end_offset(symbols, end_offset()),
            calc_end_offset(externs, end_offset()),
            modname.offset });
        exprs.size = next_offset - exprs.offset;
    }

    if (relocs.present) {
        size_t next_offset = std::min({
            calc_end_offset(symbols, end_offset()),
            calc_end_offset(externs, end_offset()),
            modname.offset });
        relocs.size = next_offset - relocs.offset;
    }

    if (symbols.present) {
        size_t next_offset = std::min({
            calc_end_offset(externs, end_offset()),
            modname.offset });
        symbols.size = next_offset - symbols.offset;
    }

    if (externs.present) {
        size_t next_offset = modname.offset;
        externs.size = next_offset - externs.offset;
    }

    if (sections.present) {
        size_t next_offset = std::min({
            calc_end_offset(strings, end_offset()),
            end_offset() });
        sections.size = next_offset - sections.offset;
    }

    if (strings.present) {
        size_t next_offset = end_offset();
        strings.size = next_offset - strings.offset;
    }
}

//-----------------------------------------------------------------------------

LibSchema::LibSchema(std::shared_ptr<const BinaryFile> file_)
    : CommonSchema(file_, 0, file_->size()) {

    if (type != ObjFileType::Library) {
        invalid_file_error("invalid library file");
    }

    size_t ptr = offset_after_signature();

    // symbol index
    if (obj_features(version).has_symbol_index) {
        symbol_index = load_offset(ptr, "symbol index");
    }
    else {
        symbol_index = SectionInfo();
    }

    // string table pointer
    if (obj_features(version).has_string_table) {
        strings = load_offset(ptr, "string table");
    }
    else {
        strings = SectionInfo();
    }

    // compute sizes of sections
    if (symbol_index.present) {
        size_t next_offset = std::min({
            calc_end_offset(strings, end_offset()),
            end_offset() });
        symbol_index.size = next_offset - symbol_index.offset;
    }

    if (strings.present) {
        size_t next_offset = end_offset();
        strings.size = next_offset - strings.offset;
    }

    // object modules
    while (true) {
        size_t next_module = file->get_dword(ptr);
        size_t module_size = file->get_dword(ptr);

        if (next_module != OffsetNotPresent && next_module > end_offset()) {
            invalid_file_error("invalid module pointer");
        }

        if (ptr + module_size > end_offset()) {
            fatal_error("invalid module size");
        }

        if (module_size > 0) {		// not deleted
            size_t end_module = std::min({
                ptr + module_size,
                calc_end_offset(symbol_index, end_offset()),
                calc_end_offset(strings, end_offset()),
                end_offset() });

            // store information on module
            SectionInfo info(ptr, end_module - ptr);
            size_t index = modules.size();
            modules.push_back(info);
            offset_to_index[info.offset] = index;
        }

        if (next_module == OffsetNotPresent) {
            break; 		// last module in chain
        }
        else {
            ptr = next_module;
        }
    }
}

//-----------------------------------------------------------------------------
// Module name
//-----------------------------------------------------------------------------

void ObjModname::dump(DumpContext ctx) const {
    ctx.line("ObjModname: " + std::string(name()));
}

void ObjModname::dump_short() const {
    std::cout << "  Name: " << name() << std::endl;
}

size_t ObjModname::pack(BinaryData& bin_data, StringTable& strings) const {
    size_t start_offset = bin_data.size();
    StringId id = strings.intern(name());
    bin_data.put_dword(id.id());
    return start_offset;
}

void ObjModname::unpack(std::shared_ptr<const BinaryFile> file, int version,
                        const StringTable& strings, size_t ptr) {
    // name
    if (obj_features(version).has_string_table) {
        StringId id = StringId(file->get_dword(ptr));
        set_name(strings.view(id));
    }
    else if (obj_features(version).has_word_strings) {
        std::string_view modname = file->get_word_string_view(ptr);
        set_name(modname);
    }
    else {
        std::string_view modname = file->get_byte_string_view(ptr);
        set_name(modname);
    }
}

//-----------------------------------------------------------------------------
// Expression
//-----------------------------------------------------------------------------

void ObjExpr::dump(DumpContext ctx) const {
    ctx.line("ObjExpr:");
    DumpContext child_ctx = ctx.child();
    SourceLoc loc(filename_id, line, 1);
    child_ctx.line("Location: " + loc.to_string());
    child_ctx.line("Text: " + escape_string(text()));
    child_ctx.line("Range: " + to_string(range));
    child_ctx.line("ASMPC: " + int_to_hex(asmpc));
    child_ctx.line("Patch ptr: " + int_to_hex(patch_ptr));
    child_ctx.line("Opcode size: " + std::to_string(opcode_size));
    if (!section_name().empty()) {
        child_ctx.line("Section: " + std::string(section_name()));
    }
    if (!target_name().empty()) {
        child_ctx.line("Target: " + std::string(target_name()));
    }
}

void ObjExpr::dump_exprs(DumpContext ctx, const std::vector<ObjExpr>& exprs) {
    if (!exprs.empty()) {
        ctx.line("Expressions:");
        DumpContext child_ctx = ctx.child();
        for (auto& expr : exprs) {
            expr.dump(child_ctx);
        }
    }
}

void ObjExpr::dump_short() const {
    std::cout << "    E "
              << std::left << std::setw(5) << to_short_string(range)
              << std::right
              << " " << int_to_hex(asmpc)
              << " " << int_to_hex(patch_ptr)
              << " " << opcode_size
              << ": ";
    if (!target_name_id.empty()) {
        std::cout << target_name() << " := ";
    }
    std::cout << text()
              << " (section " << section_name_str() << ")"
              << " (file " << filename_str() << ":" << line << ")" << std::endl;
}

void ObjExpr::dump_exprs_short(const std::vector<ObjExpr>& exprs) {
    if (!exprs.empty()) {
        std::cout << "  Expressions:" << std::endl;
        for (auto& expr : exprs) {
            expr.dump_short();
        }
    }
}

void ObjExpr::pack(BinaryData& bin_data, StringTable& strings) const {
    bin_data.put_dword(static_cast<uint32_t>(range));

    StringId id = strings.intern(filename());
    bin_data.put_dword(id.id());
    bin_data.put_dword(static_cast<uint32_t>(line));

    id = strings.intern(section_name());
    bin_data.put_dword(id.id());

    bin_data.put_dword(static_cast<uint32_t>(asmpc));
    bin_data.put_dword(static_cast<uint32_t>(patch_ptr));
    bin_data.put_dword(static_cast<uint32_t>(opcode_size));

    id = strings.intern(target_name());
    bin_data.put_dword(id.id());

    id = strings.intern(text());
    bin_data.put_dword(id.id());
}

size_t ObjExpr::pack_exprs(BinaryData& bin_data, StringTable& strings,
                           const std::vector<ObjExpr>& exprs) {
    if (exprs.empty()) {
        return OffsetNotPresent;
    }

    size_t start_offset = bin_data.size();
    for (auto& expr : exprs) {
        expr.pack(bin_data, strings);
    }

    // end marker
    bin_data.put_dword(0);

    return start_offset;
}

bool ObjExpr::unpack(std::shared_ptr<const BinaryFile> file, int version,
                     const StringTable& strings, size_t& ptr, StringId& last_filename_id) {
    // get range type
    range = ObjRangeType::Undefined;
    if (obj_features(version).has_expr_range_dword) {
        range = static_cast<ObjRangeType>(file->get_dword(ptr));
    }
    else {
        char range_char = static_cast<char>(file->get_byte(ptr));
        range = parse_old_range_type(range_char);
    }
    if (range == ObjRangeType::Undefined) {
        return false; // end of expressions
    }

    // filename and line number
    if (obj_features(version).has_string_table) {
        StringId id = StringId(file->get_dword(ptr));
        set_filename(strings.view(id));
        line = file->get_dword(ptr);
    }
    else if (obj_features(version).has_expr_file_line) {
        std::string_view filename = file->get_word_string_view(ptr);
        set_filename(filename);
        line = file->get_dword(ptr);

        if (filename_id.empty()) {
            filename_id = last_filename_id;
        }
        else {
            last_filename_id = filename_id;
        }
    }

    // section
    if (obj_features(version).has_sections) {
        if (obj_features(version).has_string_table) {
            StringId id = StringId(file->get_dword(ptr));
            set_section_name(strings.view(id));
        }
        else if (obj_features(version).has_word_strings) {
            std::string_view section_name = file->get_word_string_view(ptr);
            set_section_name(section_name);
        }
        else {
            std::string_view section_name = file->get_byte_string_view(ptr);
            set_section_name(section_name);
        }
    }

    // asmpc
    if (obj_features(version).has_expr_asmpc_dword) {
        asmpc = file->get_dword(ptr);
    }
    else if (obj_features(version).has_expr_asmpc_word) {
        asmpc = file->get_word(ptr);
    }

    // patch pointer
    if (obj_features(version).has_expr_patch_ptr_dword) {
        patch_ptr = file->get_dword(ptr);
    }
    else {
        patch_ptr = file->get_word(ptr);
    }

    // opcode size
    if (obj_features(version).has_expr_opcode_size) {
        opcode_size = file->get_dword(ptr);
    }

    // target name
    if (obj_features(version).has_expr_target_name) {
        if (obj_features(version).has_string_table) {
            StringId id = StringId(file->get_dword(ptr));
            set_target_name(strings.view(id));
        }
        else if (obj_features(version).has_word_strings) {
            std::string_view target_name = file->get_word_string_view(ptr);
            set_target_name(target_name);
        }
        else {
            std::string_view target_name = file->get_byte_string_view(ptr);
            set_target_name(target_name);
        }
    }

    // expression text
    if (obj_features(version).has_string_table) {
        StringId id = StringId(file->get_dword(ptr));
        set_text(strings.view(id));
    }
    else if (obj_features(version).has_expr_word_text) {
        std::string_view text = file->get_word_string_view(ptr);
        set_text(text);
    }
    else {
        std::string_view text = file->get_byte_string_view(ptr);
        set_text(text);

        uint8_t end_marker = file->get_byte(ptr);
        if (end_marker != 0) {
            fatal_error("missing expression end marker in '" +
                        std::string(file->filename()) + "'");
        }
    }

    return true;

}

void ObjExpr::unpack_exprs(std::shared_ptr<const BinaryFile> file, int version,
                           const StringTable& strings, size_t ptr, size_t end_ptr,
                           std::vector<ObjExpr>& exprs) {
    exprs.clear();

    // reuse filename for consecutive expressions with same file
    StringId last_filename_id;
    while (ptr < end_ptr) {
        ObjExpr expr;
        if (!expr.unpack(file, version, strings, ptr, last_filename_id)) {
            break; // end of expressions
        }
        exprs.push_back(std::move(expr));
    }
}

//-----------------------------------------------------------------------------
// Relocation
//-----------------------------------------------------------------------------

void ObjReloc::dump(DumpContext ctx) const {
    ctx.line("ObjReloc:");
    DumpContext child_ctx = ctx.child();
    SourceLoc loc(filename_id, line, 1);
    child_ctx.line("Location: " + loc.to_string());
    child_ctx.line("Patch section: " + std::string(patch_section_name_str()));
    child_ctx.line("Patch ptr: " + int_to_hex(patch_ptr));
    child_ctx.line("Range: " + to_string(range));
    child_ctx.line("Value section: " + std::string(value_section_name_str()));
    child_ctx.line("Value offset: " + int_to_hex(offset));
}

void ObjReloc::dump_relocs(DumpContext ctx,
                           const std::vector<ObjReloc>& relocs) {
    if (!relocs.empty()) {
        ctx.line("Relocations:");
        DumpContext child_ctx = ctx.child();
        for (auto& reloc : relocs) {
            reloc.dump(child_ctx);
        }
    }
}

void ObjReloc::dump_short() const {
    std::cout << "    R "
              << std::left << std::setw(5) << to_short_string(range)
              << std::right
              << " " << int_to_hex(patch_ptr)
              << ": " << value_section_name_str() << "+" << int_to_hex(offset)
              << " (section " << patch_section_name_str() << ")"
              << ")" << " (file " << filename_str() << ":" << line << ")" << std::endl
              << ":" << line << ")" << std::endl;
}

void ObjReloc::dump_relocs_short(const std::vector<ObjReloc>& relocs) {
    if (!relocs.empty()) {
        std::cout << "  Relocations:" << std::endl;
        for (auto& reloc : relocs) {
            reloc.dump_short();
        }
    }
}

void ObjReloc::pack(BinaryData& bin_data, StringTable& strings) const {
    bin_data.put_dword(static_cast<uint32_t>(range));

    StringId id = strings.intern(filename());
    bin_data.put_dword(id.id());
    bin_data.put_dword(static_cast<uint32_t>(line));

    id = strings.intern(patch_section_name());
    bin_data.put_dword(id.id());

    bin_data.put_dword(static_cast<uint32_t>(patch_ptr));

    id = strings.intern(value_section_name());
    bin_data.put_dword(id.id());

    bin_data.put_dword(static_cast<uint32_t>(offset));
}

size_t ObjReloc::pack_relocs(BinaryData& bin_data, StringTable& strings,
                             const std::vector<ObjReloc>& relocs) {
    if (relocs.empty()) {
        return OffsetNotPresent;
    }

    size_t start_offset = bin_data.size();
    for (auto& reloc : relocs) {
        reloc.pack(bin_data, strings);
    }

    // end marker
    bin_data.put_dword(0);

    return start_offset;
}

bool ObjReloc::unpack(std::shared_ptr<const BinaryFile> file, int /*version*/,
                      const StringTable& strings, size_t& ptr) {
    // get range type
    range = static_cast<ObjRangeType>(file->get_dword(ptr));
    if (range == ObjRangeType::Undefined) {
        return false; // end of relocations
    }

    // filename and line number
    StringId id = StringId(file->get_dword(ptr));
    set_filename(strings.view(id));
    line = file->get_dword(ptr);

    // patch section
    id = StringId(file->get_dword(ptr));
    set_patch_section_name(g_strings.view(id));

    // patch pointer
    patch_ptr = file->get_dword(ptr);

    // value section
    id = StringId(file->get_dword(ptr));
    set_value_section_name(strings.view(id));

    // offset
    offset = static_cast<int32_t>(file->get_dword(ptr));

    return true;
}

void ObjReloc::unpack_relocs(std::shared_ptr<const BinaryFile> file,
                             int version,
                             const StringTable& strings, size_t ptr, size_t end_ptr,
                             std::vector<ObjReloc>& relocs) {
    relocs.clear();
    while (ptr < end_ptr) {
        ObjReloc reloc;
        if (!reloc.unpack(file, version, strings, ptr)) {
            break; // end of relocations
        }
        relocs.push_back(std::move(reloc));
    }
}

//-----------------------------------------------------------------------------
// Symbol
//-----------------------------------------------------------------------------

void ObjSymbol::dump(DumpContext ctx) const {
    ctx.line("ObjSymbol: " + std::string(symbol_name()));
    DumpContext child_ctx = ctx.child();
    SourceLoc loc(filename(), line, 1);
    child_ctx.line("Location: " + loc.to_string());
    child_ctx.line("Scope: " + to_string(scope));
    child_ctx.line("Type: " + to_string(type));
    child_ctx.line("Section: " + std::string(section_name_str()));
    child_ctx.line("Value: " + int_to_hex(value));
}

void ObjSymbol::dump_symbols(DumpContext ctx,
                             const std::vector<ObjSymbol>& symbols) {
    if (!symbols.empty()) {
        ctx.line("Symbols:");
        DumpContext child_ctx = ctx.child();
        for (auto& symbol : symbols) {
            symbol.dump(child_ctx);
        }
    }
}

void ObjSymbol::dump_short() const {
    std::cout << "    " << to_short_string(scope)
              << " " << to_short_string(type)
              << " " << int_to_hex(value)
              << ": " << symbol_name()
              << " (section " << section_name_str() << ")"
              << " (file " << filename_str() << ":" << line << ")" << std::endl;
}

void ObjSymbol::dump_symbols_short(const std::vector<ObjSymbol>& symbols) {
    if (!symbols.empty()) {
        std::cout << "  Symbols:" << std::endl;
        for (auto& symbol : symbols) {
            symbol.dump_short();
        }
    }
}

void ObjSymbol::pack(BinaryData& bin_data, StringTable& strings) const {
    bin_data.put_dword(static_cast<uint32_t>(scope));
    bin_data.put_dword(static_cast<uint32_t>(type));

    StringId id = strings.intern(section_name());
    bin_data.put_dword(id.id());

    bin_data.put_dword(static_cast<uint32_t>(value));

    id = strings.intern(symbol_name());
    bin_data.put_dword(id.id());

    id = strings.intern(filename());
    bin_data.put_dword(id.id());
    bin_data.put_dword(static_cast<uint32_t>(line));
}

size_t ObjSymbol::pack_symbols(BinaryData& bin_data, StringTable& strings,
                               const std::vector<ObjSymbol>& symbols) {
    if (symbols.empty()) {
        return OffsetNotPresent;
    }

    size_t start_offset = bin_data.size();
    for (auto& sym : symbols) {
        sym.pack(bin_data, strings);
    }

    // end marker
    bin_data.put_dword(0);

    return start_offset;
}

bool ObjSymbol::unpack(std::shared_ptr<const BinaryFile> file, int version,
                       const StringTable& strings, size_t& ptr) {
    // scope
    scope = ObjSymbolScope::Undefined;
    if (obj_features(version).has_symbol_scope_dword) {
        scope = static_cast<ObjSymbolScope>(file->get_dword(ptr));
    }
    else {
        char scope_char = static_cast<char>(file->get_byte(ptr));
        scope = parse_old_symbol_scope(scope_char);
    }
    if (scope == ObjSymbolScope::Undefined) {
        return false; // end of symbols
    }

    // type
    type = ObjSymbolType::Undefined;
    if (obj_features(version).has_symbol_type_dword) {
        type = static_cast<ObjSymbolType>(file->get_dword(ptr));
    }
    else {
        char type_char = static_cast<char>(file->get_byte(ptr));
        type = parse_old_symbol_type(type_char);
    }
    if (type == ObjSymbolType::Undefined) {
        fatal_error("invalid symbol type: " +
                    std::to_string(static_cast<int>(type)));
    }

    // section
    if (obj_features(version).has_sections) {
        if (obj_features(version).has_string_table) {
            StringId id = StringId(file->get_dword(ptr));
            set_section_name(strings.view(id));
        }
        else if (obj_features(version).has_word_strings) {
            std::string_view section_name = file->get_word_string_view(ptr);
            set_section_name(section_name);
        }
        else {
            std::string_view section_name = file->get_byte_string_view(ptr);
            set_section_name(section_name);
        }
    }

    // value
    value = static_cast<int32_t>(file->get_dword(ptr));

    // name
    if (obj_features(version).has_string_table) {
        StringId id = StringId(file->get_dword(ptr));
        set_symbol_name(strings.view(id));
    }
    else if (obj_features(version).has_word_strings) {
        std::string_view symbol_name = file->get_word_string_view(ptr);
        set_symbol_name(symbol_name);
    }
    else {
        std::string_view symbol_name = file->get_byte_string_view(ptr);
        set_symbol_name(symbol_name);
    }

    // definition location
    if (obj_features(version).has_symbol_file_line) {
        if (obj_features(version).has_string_table) {
            StringId id = StringId(file->get_dword(ptr));
            set_filename(strings.view(id));
        }
        else if (obj_features(version).has_word_strings) {
            std::string_view filename = file->get_word_string_view(ptr);
            set_filename(filename);
        }
        else {
            std::string_view filename = file->get_byte_string_view(ptr);
            set_filename(filename);
        }

        line = file->get_dword(ptr);
    }

    return true;
}

void ObjSymbol::unpack_symbols(std::shared_ptr<const BinaryFile> file,
                               int version,
                               const StringTable& strings, size_t ptr, size_t end_ptr,
                               std::vector<ObjSymbol>& symbols) {
    symbols.clear();
    while (ptr < end_ptr) {
        ObjSymbol symbol;
        if (!symbol.unpack(file, version, strings, ptr)) {
            break; // end of symbols
        }
        symbols.push_back(std::move(symbol));
    }
}

//-----------------------------------------------------------------------------
// Extern
//-----------------------------------------------------------------------------

void ObjExtern::dump(DumpContext ctx) const {
    ctx.line("Symbol: " + std::string(symbol_name()));
}

void ObjExtern::dump_externs(DumpContext ctx,
                             const std::vector<ObjExtern>& externs) {
    if (!externs.empty()) {
        ctx.line("ObjExterns:");
        DumpContext child_ctx = ctx.child();
        for (auto& extern_ : externs) {
            extern_.dump(child_ctx);
        }
    }
}

void ObjExtern::dump_short() const {
    std::cout << "    U         " << symbol_name() << std::endl;
}

void ObjExtern::dump_externs_short(const std::vector<ObjExtern>& externs) {
    if (!externs.empty()) {
        std::cout << "  Externs:" << std::endl;
        for (auto& extern_ : externs) {
            extern_.dump_short();
        }
    }
}

void ObjExtern::pack(BinaryData& bin_data, StringTable& strings) const {
    StringId id = strings.intern(symbol_name());
    bin_data.put_dword(id.id());
}

size_t ObjExtern::pack_externs(BinaryData& bin_data, StringTable& strings,
                               const std::vector<ObjExtern>& externs) {
    if (externs.empty()) {
        return OffsetNotPresent;
    }

    size_t start_offset = bin_data.size();
    for (auto& extern_ : externs) {
        extern_.pack(bin_data, strings);
    }

    // end marker
    bin_data.put_dword(0);

    return start_offset;
}

bool ObjExtern::unpack(std::shared_ptr<const BinaryFile> file, int version,
                       const StringTable& strings, size_t& ptr) {
    // name
    if (obj_features(version).has_string_table) {
        StringId id(file->get_dword(ptr));
        if (id.empty()) {
            return false;	// end marker
        }
        set_symbol_name(strings.view(id));
    }
    else if (obj_features(version).has_word_strings) {
        std::string_view symbol_name = file->get_word_string_view(ptr);
        if (symbol_name.empty()) {
            return false;	// end marker
        }
        set_symbol_name(symbol_name);
    }
    else {
        std::string_view symbol_name = file->get_byte_string_view(ptr);
        if (symbol_name.empty()) {
            return false;	// end marker
        }
        set_symbol_name(symbol_name);
    }

    return true;
}

void ObjExtern::unpack_externs(std::shared_ptr<const BinaryFile> file,
                               int version,
                               const StringTable& strings, size_t ptr, size_t end_ptr,
                               std::vector<ObjExtern>& externs) {
    externs.clear();
    while (ptr < end_ptr) {
        ObjExtern extern_;
        if (!extern_.unpack(file, version, strings, ptr)) {
            break; // end of externs
        }
        externs.push_back(std::move(extern_));
    }
}

//-----------------------------------------------------------------------------
// Section
//-----------------------------------------------------------------------------

void ObjSection::dump(DumpContext ctx) const {
    ctx.line("ObjSection: " + std::string(section_name_str()));
    DumpContext child_ctx = ctx.child();
    if (base_address == OrgSectionSplit) {
        child_ctx.line("ORG: section split");
    }
    else if (base_address != OrgNotDefined) {
        child_ctx.line("ORG: " + int_to_hex(base_address));
    }
    child_ctx.line("Align: " + std::to_string(align));
    DumpContext grandchild_ctx = child_ctx.child();
    print_bytes(grandchild_ctx);
}

void ObjSection::dump_sections(DumpContext ctx,
                               const std::vector<ObjSection>& sections) {
    if (!sections.empty()) {
        ctx.line("Sections:");
        DumpContext child_ctx = ctx.child();
        for (auto& section : sections) {
            section.dump(child_ctx);
        }
    }
}

void ObjSection::dump_short() const {
    std::cout << "  Section ";
    if (section_name().empty()) {
        std::cout << "\"\"";
    }
    else {
        std::cout << section_name();
    }
    std::cout << ": " << bytes.size() << " bytes";
    if (base_address == OrgSectionSplit) {
        std::cout << ", section split";
    }
    else if (base_address != OrgNotDefined) {
        std::cout << ", ORG " << int_to_hex(base_address);
    }
    if (align > 1) {
        std::cout << ", ALIGN " << align;
    }
    std::cout << std::endl;

    // Print bytes using DumpContext with indentation level 1
    DumpContext ctx(std::cout, 1);
    print_bytes(ctx);
}

void ObjSection::dump_sections_short(const std::vector<ObjSection>& sections) {
    if (!sections.empty()) {
        std::cout << "  Sections:" << std::endl;
        for (auto& section : sections) {
            section.dump_short();
        }
    }
}

void ObjSection::pack(BinaryData& bin_data, StringTable& strings) const {
    // size
    size_t size = bytes.size();
    bin_data.put_dword(static_cast<uint32_t>(size));

    // section name
    StringId id = strings.intern(section_name());
    bin_data.put_dword(id.id());

    // org
    bin_data.put_dword(static_cast<uint32_t>(base_address));

    // align
    bin_data.put_dword(static_cast<uint32_t>(align));

    // bytes
    bin_data.put_data(bytes.data(), size);

    // align
    bin_data.align(4);
}

size_t ObjSection::pack_sections(BinaryData& bin_data, StringTable& strings,
                                 const std::vector<ObjSection>& sections) {
    if (sections.empty()) {
        return OffsetNotPresent;
    }

    size_t start_offset = bin_data.size();
    for (auto& section : sections) {
        section.pack(bin_data, strings);
    }

    // end marker
    bin_data.put_dword(OffsetNotPresent);

    return start_offset;
}

bool ObjSection::unpack(std::shared_ptr<const BinaryFile> file, int version,
                        const StringTable& strings, size_t& ptr) {
    if (obj_features(version).has_sections) {
        // size
        size_t size = file->get_dword(ptr);
        if (size == OffsetNotPresent) {
            return false;	// end terminator
        }

        // section
        if (obj_features(version).has_string_table) {
            StringId id = StringId(file->get_dword(ptr));
            set_section_name(strings.view(id));
        }
        else if (obj_features(version).has_word_strings) {
            std::string_view section_name = file->get_word_string_view(ptr);
            set_section_name(section_name);
        }
        else {
            std::string_view section_name = file->get_byte_string_view(ptr);
            set_section_name(section_name);
        }

        // org
        if (obj_features(version).has_section_org) {
            base_address = file->get_dword(ptr);
        }
        else {
            base_address = OrgNotDefined;
        }

        // align
        if (obj_features(version).has_section_align) {
            align = file->get_dword(ptr);
        }
        else {
            align = 1;
        }

        // bytes
        const uint8_t* data = file->get_data(ptr, size);
        bytes.insert(bytes.end(), data, data + size);

        // alignment
        if (obj_features(version).has_file_data_aligned) {
            file->align_ptr(ptr);
        }
    }
    else {
        // size
        size_t size = file->get_word(ptr);
        if (size == 0xFFFF) {
            size = 0x10000;
        }

        // bytes
        const uint8_t* data = file->get_data(ptr, size);
        bytes.insert(bytes.end(), data, data + size);
    }

    return true;
}

void ObjSection::unpack_sections(std::shared_ptr<const BinaryFile> file,
                                 int version, const StringTable& strings, size_t ptr, size_t end_ptr,
                                 std::vector<ObjSection>& sections) {
    sections.clear();
    while (ptr < end_ptr) {
        ObjSection section;
        if (!section.unpack(file, version, strings, ptr)) {
            break; // end of sections
        }
        sections.push_back(std::move(section));
    }
}

void ObjSection::print_bytes(DumpContext ctx) const {
    for (size_t addr = 0; addr < bytes.size(); addr++) {
        if ((addr % 16) == 0) {
            std::ostringstream oss;
            oss << "C $"
                << std::uppercase << std::hex
                << std::setfill('0') << std::setw(4)
                << addr
                << std::nouppercase << std::dec
                << std::setfill(' ')
                << ":";

            // Collect up to 16 bytes for this line
            for (size_t i = 0; i < 16 && (addr + i) < bytes.size(); i++) {
                oss << " "
                    << std::uppercase << std::hex
                    << std::setfill('0') << std::setw(2)
                    << static_cast<uint>(bytes[addr + i])
                    << std::nouppercase << std::dec
                    << std::setfill(' ');
            }

            ctx.line(oss.str());
        }
    }
}

//-----------------------------------------------------------------------------
// Module
//-----------------------------------------------------------------------------

StringTable* ObjModule::strings() {
    if (!strings_) {
        strings_ = std::make_unique<StringTable>();
    }

    // check if unpack was called
    if (obj_schema_ &&
            obj_schema_->strings.present &&
            !obj_schema_->strings.loaded) {
        strings_->unpack(obj_schema_->file, obj_schema_->strings.offset);
        obj_schema_->strings.loaded = true;
    }
    return strings_.get();
}

ObjModname* ObjModule::modname() {
    if (!modname_) {
        modname_ = std::make_unique<ObjModname>();
    }

    // check if unpack was called
    if (obj_schema_ &&
            obj_schema_->modname.present &&
            !obj_schema_->modname.loaded) {
        modname_->unpack(obj_schema_->file, obj_schema_->version,
                         *strings(), obj_schema_->modname.offset);
        obj_schema_->modname.loaded = true;
    }
    return modname_.get();
}

std::vector<ObjExpr>* ObjModule::exprs() {
    if (!exprs_) {
        exprs_ = std::make_unique<std::vector<ObjExpr>>();
    }

    // check if unpack was called
    if (obj_schema_ &&
            obj_schema_->exprs.present &&
            !obj_schema_->exprs.loaded) {
        ObjExpr::unpack_exprs(obj_schema_->file, obj_schema_->version,
                              *strings(),
                              obj_schema_->exprs.offset,
                              obj_schema_->exprs.offset + obj_schema_->exprs.size,
                              *exprs_);
        obj_schema_->exprs.loaded = true;
    }
    return exprs_.get();
}

std::vector<ObjReloc>* ObjModule::relocs() {
    if (!relocs_) {
        relocs_ = std::make_unique<std::vector<ObjReloc>>();
    }

    // check if unpack was called
    if (obj_schema_ &&
            obj_schema_->relocs.present &&
            !obj_schema_->relocs.loaded) {
        ObjReloc::unpack_relocs(obj_schema_->file, obj_schema_->version,
                                *strings(),
                                obj_schema_->relocs.offset,
                                obj_schema_->relocs.offset + obj_schema_->relocs.size,
                                *relocs_);
        obj_schema_->relocs.loaded = true;
    }
    return relocs_.get();
}

std::vector<ObjSymbol>* ObjModule::symbols() {
    if (!symbols_) {
        symbols_ = std::make_unique<std::vector<ObjSymbol>>();
    }

    // check if unpack was called
    if (obj_schema_ &&
            obj_schema_->symbols.present &&
            !obj_schema_->symbols.loaded) {
        ObjSymbol::unpack_symbols(obj_schema_->file, obj_schema_->version,
                                  *strings(),
                                  obj_schema_->symbols.offset,
                                  obj_schema_->symbols.offset + obj_schema_->symbols.size,
                                  *symbols_);
        obj_schema_->symbols.loaded = true;
    }

    return symbols_.get();
}

std::vector<ObjExtern>* ObjModule::externs() {
    if (!externs_) {
        externs_ = std::make_unique<std::vector<ObjExtern>>();
    }

    // check if unpack was called
    if (obj_schema_ &&
            obj_schema_->externs.present &&
            !obj_schema_->externs.loaded) {
        ObjExtern::unpack_externs(obj_schema_->file, obj_schema_->version,
                                  *strings(),
                                  obj_schema_->externs.offset,
                                  obj_schema_->externs.offset + obj_schema_->externs.size,
                                  *externs_);
        obj_schema_->externs.loaded = true;
    }

    return externs_.get();
}

std::vector<ObjSection>* ObjModule::sections() {
    if (!sections_) {
        sections_ = std::make_unique<std::vector<ObjSection>>();
    }

    // check if unpack was called
    if (obj_schema_ &&
            obj_schema_->sections.present &&
            !obj_schema_->sections.loaded) {
        ObjSection::unpack_sections(obj_schema_->file, obj_schema_->version,
                                    *strings(),
                                    obj_schema_->sections.offset,
                                    obj_schema_->sections.offset + obj_schema_->sections.size,
                                    *sections_);
        obj_schema_->sections.loaded = true;
    }

    return sections_.get();
}

void ObjModule::dump(DumpContext ctx) {
    ctx.line("ObjModule: " + std::string(modname()->name()));
    auto c = ctx.child();
    c.line("CPU: " + to_string(cpu_id()));
    if (swap_ixiy()) {
        c.line("Swap IX/IY: true");
    }
    if (base_address() == OrgSectionSplit) {
        c.line("Base address: section split");
    }
    else if (base_address() != OrgNotDefined) {
        c.line("Base address: " + int_to_hex(base_address()));
    }

    ObjExpr::dump_exprs(c, *exprs());
    ObjReloc::dump_relocs(c, *relocs());
    ObjSymbol::dump_symbols(c, *symbols());
    ObjExtern::dump_externs(c, *externs());
    ObjSection::dump_sections(c, *sections());
}

void ObjModule::dump_short() {
    std::cout << "Object  file " << filename()
              << " at " << int_to_hex(base_offset()) << std::endl;
    std::cout << "  Name: " << modname()->name() << std::endl;
    if (base_address() != OrgNotDefined && base_address() != OrgSectionSplit) {
        std::cout << "  ORG:  " << int_to_hex(base_address()) << std::endl;
    }
    std::cout << "  CPU:  " << to_string(cpu_id()) << " ";
    if (swap_ixiy()) {
        std::cout << "(-IXIY)";
    }
    std::cout << std::endl;
    ObjSection::dump_sections_short(*sections());
    ObjSymbol::dump_symbols_short(*symbols());
    ObjExtern::dump_externs_short(*externs());
    ObjExpr::dump_exprs_short(*exprs());
    ObjReloc::dump_relocs_short(*relocs());
    if (strings()->size() > 1) {
        std::cout << "  Strings: " << strings()->size() << std::endl;
        for (uint i = 1; i < strings()->size(); i++) {
            std::cout << "    S "
                      << std::setw(3) << i << " = \""
                      << strings()->view(StringId(i)) << "\"" << std::endl;
        }
    }
}

void ObjModule::pack(BinaryData& bin_data) {
    // mark the start for the relative pointers
    set_base_offset(bin_data.size());

    // add signature
    bin_data.put_string(obj_file_signature());

    // add CPU and IXIY
    bin_data.put_dword(static_cast<uint32_t>(cpu_id()));
    bin_data.put_dword(static_cast<uint32_t>(swap_ixiy()));

    // append placeholders for 6 pointers to file sections
    size_t header_ptr = bin_data.size();
    for (int i = 0; i < 7; i++) {
        bin_data.put_dword(OffsetNotPresent);
    }

    // write each of the sections and collect the addresses
    strings()->clear();
    size_t exprs_ptr = ObjExpr::pack_exprs(bin_data, *strings(), *exprs());
    size_t relocs_ptr = ObjReloc::pack_relocs(bin_data, *strings(), *relocs());
    size_t symbols_ptr = ObjSymbol::pack_symbols(bin_data, *strings(), *symbols());
    size_t externs_ptr = ObjExtern::pack_externs(bin_data, *strings(), *externs());
    size_t modname_ptr = modname()->pack(bin_data, *strings());
    size_t sections_ptr = ObjSection::pack_sections(bin_data, *strings(),
                          *sections());
    size_t strings_ptr = bin_data.size();
    strings()->pack(bin_data);

    // write pointers to areas
    auto calc_offset = [](size_t offset, size_t base) -> size_t {
        if (offset == OffsetNotPresent) {
            return OffsetNotPresent;
        }
        else {
            return offset - base;
        }
    };

    size_t ptr = header_ptr;
    bin_data.put_dword_at(ptr,
                          static_cast<uint32_t>(calc_offset(modname_ptr, base_offset())));
    bin_data.put_dword_at(ptr,
                          static_cast<uint32_t>(calc_offset(exprs_ptr, base_offset())));
    bin_data.put_dword_at(ptr,
                          static_cast<uint32_t>(calc_offset(relocs_ptr, base_offset())));
    bin_data.put_dword_at(ptr,
                          static_cast<uint32_t>(calc_offset(symbols_ptr, base_offset())));
    bin_data.put_dword_at(ptr,
                          static_cast<uint32_t>(calc_offset(externs_ptr, base_offset())));
    bin_data.put_dword_at(ptr,
                          static_cast<uint32_t>(calc_offset(sections_ptr, base_offset())));
    bin_data.put_dword_at(ptr,
                          static_cast<uint32_t>(calc_offset(strings_ptr, base_offset())));
}

void ObjModule::unpack(std::shared_ptr<const BinaryFile> file, size_t ptr) {
    // get schema
    obj_schema_ = std::make_unique<ObjSchema>(file, ptr, file->size() - ptr);
    set_filename(obj_schema_->filename());
    set_base_offset(obj_schema_->base_offset);

    // get global attributes
    set_cpu_id(obj_schema_->cpu_id);
    set_swap_ixiy(obj_schema_->swap_ixiy);
    set_base_address(obj_schema_->base_address);

    // the sections are loaded on demand
}

//-----------------------------------------------------------------------------
// Library
//-----------------------------------------------------------------------------

StringTable* ObjLibrary::strings() {
    if (!strings_) {
        strings_ = std::make_unique<StringTable>();
    }

    // check if unpack was called
    if (lib_schema_ &&
            lib_schema_->strings.present &&
            !lib_schema_->strings.loaded) {
        strings_->unpack(lib_schema_->file, lib_schema_->strings.offset);
        lib_schema_->strings.loaded = true;
    }
    return strings_.get();
}

std::vector<ObjModule>* ObjLibrary::modules() {
    if (!modules_) {
        modules_ = std::make_unique<std::vector<ObjModule>>();
    }

    // check if unpack was called
    if (lib_schema_ &&
            !lib_schema_->modules.empty() &&
            !lib_schema_->modules_loaded) {
        modules_->clear();
        for (auto& info : lib_schema_->modules) {
            ObjModule mod;
            mod.unpack(lib_schema_->file, info.offset);
            modules_->push_back(std::move(mod));
        }
        lib_schema_->modules_loaded = true;
    }
    return modules_.get();
}

std::unordered_map<CpuKey, std::unordered_map<StringId, size_t>>* ObjLibrary::symbol_index() {
    if (!symbol_index_) {
        symbol_index_ =
            std::make_unique<std::unordered_map<CpuKey, std::unordered_map<StringId, size_t>>>();
    }

    // check if unpack was called
    if (lib_schema_ &&
            lib_schema_->symbol_index.present &&
            !lib_schema_->symbol_index.loaded) {

        symbol_index_->clear();
        size_t header_ptr = lib_schema_->symbol_index.offset;
        while (true) {
            // get each CPU-swap_ixiy entry
            CPU cpu_id = static_cast<CPU>(lib_schema_->file->get_dword(header_ptr));
            if (cpu_id == CPU::none) {
                break;  // terminator
            }
            bool swap_ixiy = !!lib_schema_->file->get_dword(header_ptr);
            size_t list_ptr = lib_schema_->file->get_dword(header_ptr);
            size_t list_size = lib_schema_->file->get_dword(header_ptr);

            CpuKey cpu_key(cpu_id, swap_ixiy);
            for (size_t i = 0; i < list_size; i++) {
                StringId symbol_name_id = StringId(lib_schema_->file->get_dword(list_ptr));
                size_t mod_base_offset = lib_schema_->file->get_dword(header_ptr);
                (*symbol_index_)[cpu_key][symbol_name_id] = mod_base_offset;
            }
        }

        lib_schema_->symbol_index.loaded = true;
    }

    return symbol_index_.get();
}

ObjModule* ObjLibrary::lookup_public_symbol(StringId sym_name_id) {
    // build/lookup the symbol-to-module map
    if (!symbol_to_module_) {
        if (lib_schema_ && lib_schema_->symbol_index.present) {
            build_symbol_to_module_map_v19();
        }
        else {
            build_symbol_to_module_map_older();
        }
    }

    // lookup the index for the current CPU and swap_ixiy
    auto it = symbol_to_module_->find(sym_name_id);
    if (it == symbol_to_module_->end()) {
        return nullptr;     // not found
    }
    else {
        return it->second;    // return the module pointer
    }
}

void ObjLibrary::dump(DumpContext ctx) {
    ctx.line("ObjLibrary:");
    auto c = ctx.child();
    if (!modules()->empty()) {
        c.line("Modules (" + std::to_string(modules()->size()) + "):");
        auto mc = c.child();
        for (auto& module_ : *modules()) {
            module_.dump(mc);
        }
    }
}

void ObjLibrary::dump_short() {
    std::cout << "Library file " << filename()
              << " at " << int_to_hex(base_offset()) << std::endl;
    for (auto& module_ : *modules()) {
        module_.dump_short();
    }
}

void ObjLibrary::pack(BinaryData& bin_data) {
    // add signature
    bin_data.put_string(lib_file_signature());

    // add symbol index and string table placeholders
    size_t symbol_index_ptr = bin_data.size();
    bin_data.put_dword(OffsetNotPresent);   // symbol index pointer
    size_t string_table_ptr = bin_data.size();
    bin_data.put_dword(OffsetNotPresent);   // string table pointer

    // add each module
    size_t prev_ptr = 0;
    for (auto& mod : *modules()) {
        // append header
        prev_ptr = bin_data.size();
        bin_data.put_dword(OffsetNotPresent);   // next module
        size_t len_ptr = bin_data.size();
        bin_data.put_dword(0);     // length of this module

        // append module
        size_t mod_pos = bin_data.size();
        mod.pack(bin_data);
        bin_data.align(4);
        size_t next_ptr = bin_data.size();
        size_t mod_size = next_ptr - mod_pos;

        // patch values
        bin_data.patch_dword(prev_ptr,
                             static_cast<uint32_t>(next_ptr));     // next module
        bin_data.patch_dword(len_ptr,
                             static_cast<uint32_t>(mod_size));      // length of this module
    }

    // mark the end of the chain
    if (prev_ptr != 0) {        // any module written
        bin_data.patch_dword(prev_ptr, OffsetNotPresent);   // next module
    }

    // now that the modules have base_offset updated by their pack() methods,
    // we can build the symbol index and string table
    build_symbol_index();

    // write the symbol index to the file
    size_t symbol_index_offset = pack_symbol_index(bin_data);
    bin_data.patch_dword(symbol_index_ptr,
                         static_cast<uint32_t>(symbol_index_offset));

    // write the string table to the file
    size_t string_table_offset = bin_data.size();
    bin_data.patch_dword(string_table_ptr,
                         static_cast<uint32_t>(string_table_offset));
    strings()->pack(bin_data);
}

void ObjLibrary::unpack(std::shared_ptr<const BinaryFile> file) {
    // get schema
    lib_schema_ = std::make_unique<LibSchema>(file);
    set_filename(lib_schema_->filename());
    set_base_offset(lib_schema_->base_offset);

    // the sections are loaded on demand
}

void ObjLibrary::build_symbol_index() {
    strings()->clear();
    symbol_index()->clear();

    for (auto code_cpu_id : cpus_specific_to_general()) {
        for (auto code_swap_ixiy : {
                    false, true
                }) {
            std::unordered_map<StringId, size_t> symbol_map;
            for (auto& mod : *modules()) {
                size_t mod_base_offset = mod.base_offset();
                if (cpu_compatible(code_cpu_id, mod.cpu_id())
                        && code_swap_ixiy == mod.swap_ixiy()) {
                    for (auto& sym : *mod.symbols()) {
                        if (sym.scope == ObjSymbolScope::Public) {
                            std::string_view sym_name = sym.symbol_name();
                            StringId sym_name_id = strings()->intern(sym_name);
                            auto it = symbol_map.find(sym_name_id);
                            if (it == symbol_map.end()) {
                                symbol_map[sym_name_id] = mod_base_offset;
                            }
                            else {
                                // duplicate symbol, keep the first one
                            }
                        }
                    }
                }
            }
            if (!symbol_map.empty()) {
                CpuKey cpu_key(code_cpu_id, code_swap_ixiy);
                (*symbol_index())[cpu_key] = std::move(symbol_map);
            }
        }
    }
}

size_t ObjLibrary::pack_symbol_index(BinaryData& bin_data) {
    if (symbol_index()->empty()) {
        return OffsetNotPresent;
    }

    size_t start_offset = bin_data.size();

    // write headers for each CPU and swap_ixiy combination that has symbols
    std::vector<size_t> symbol_map_offsets_ptrs;
    for (auto code_cpu_id : cpus_specific_to_general()) {
        for (auto swap_ixiy : {
                    false, true
                }) {
            CpuKey cpu_key(code_cpu_id, swap_ixiy);
            if (symbol_index()->count(cpu_key)) {
                const auto& symbol_map = (*symbol_index())[cpu_key];
                bin_data.put_dword(static_cast<uint32_t>(code_cpu_id));
                bin_data.put_dword(static_cast<uint32_t>(swap_ixiy));
                symbol_map_offsets_ptrs.push_back(bin_data.size());
                bin_data.put_dword(
                    OffsetNotPresent);       // placeholder for offset to symbol map
                bin_data.put_dword(static_cast<uint32_t>(symbol_map.size()));
            }
        }
    }
    bin_data.put_dword(0);  // terminator

    // write the symbol maps for each CPU and swap_ixiy combination
    std::vector<size_t> symbol_map_offsets;
    for (auto code_cpu_id : cpus_specific_to_general()) {
        for (auto swap_ixiy : {
                    false, true
                }) {
            CpuKey cpu_key(code_cpu_id, swap_ixiy);
            if (symbol_index()->count(cpu_key)) {
                symbol_map_offsets.push_back(
                    bin_data.size());      // save offset for this symbol map
                const auto& symbol_map = (*symbol_index())[cpu_key];

                // sort symbols alphabetically for deterministic output
                std::vector<StringId> sorted_sym_name_ids;
                sorted_sym_name_ids.reserve(symbol_map.size());
                for (const auto& [sym_name_id, offset] : symbol_map) {
                    sorted_sym_name_ids.push_back(sym_name_id);
                }
                std::sort(sorted_sym_name_ids.begin(), sorted_sym_name_ids.end(),
                [](const StringId & a, const StringId & b) {
                    return g_strings.view(a) < g_strings.view(b);
                });

                for (const auto& sym_name_id : sorted_sym_name_ids) {
                    const auto& offset = symbol_map.at(sym_name_id);
                    bin_data.put_dword(sym_name_id.id());
                    bin_data.put_dword(static_cast<uint32_t>(offset));
                }
            }
        }
    }

    // patch the offsets to the symbol maps
    release_assert(symbol_map_offsets.size() == symbol_map_offsets_ptrs.size());
    for (size_t i = 0; i < symbol_map_offsets.size(); i++) {
        bin_data.patch_dword(symbol_map_offsets_ptrs[i],
                             static_cast<uint32_t>(symbol_map_offsets[i]));
    }

    return start_offset;
}

void ObjLibrary::build_symbol_to_module_map_v19() {
    symbol_to_module_ =
        std::make_unique<std::unordered_map<StringId, ObjModule*>>();
    CpuKey cpu_key(lib_schema_->cur_cpu_id, lib_schema_->cur_swap_ixiy);
    std::unordered_map<StringId, size_t> symbol_map = (*symbol_index())[cpu_key];
    for (auto& [sym_name_id, mod_base_offset] : symbol_map) {
        auto it = lib_schema_->offset_to_index.find(mod_base_offset);
        if (it == lib_schema_->offset_to_index.end()) {
            lib_schema_->invalid_file_error("Invalid module base offset in symbol index: " +
                                            std::to_string(mod_base_offset));
        }
        else {
            size_t mod_index = it->second;
            if (mod_index >= modules()->size()) {
                lib_schema_->invalid_file_error("Invalid module index in symbol index: " +
                                                std::to_string(mod_index));
            }
            else {
                ObjModule* mod = &(*modules())[mod_index];
                (*symbol_to_module_)[sym_name_id] = mod;
            }
        }
    }
}

void ObjLibrary::build_symbol_to_module_map_older() {
    build_symbol_index();               // build the symbol index for older versions
    build_symbol_to_module_map_v19();   // then build the symbol to module map
}

//-----------------------------------------------------------------------------
// Drivers
//-----------------------------------------------------------------------------

void write_object_library(ObjLibrary& obj_lib, std::string_view filename) {
    if (g_args.options.verbose) {
        std::cout << "Writing object file: " << filename << std::endl;
    }

    // pack
    BinaryData bin_data;
    obj_lib.pack(bin_data);

    // write file
    std::string filename_s(filename);
    if (!write_binary_file(filename, bin_data.bytes)) {
        fatal_error("Cannot create file: " + filename_s);
    }
}

void read_object_library(ObjLibrary& obj_lib, std::string_view filename) {
    obj_lib = ObjLibrary();  // reset

    // memory-map file
    auto file = std::make_shared<BinaryFile>(filename);

    // unpack binary data
    obj_lib.unpack(file);
}

void dump_obj_lib_and_exit(ObjLibrary& obj_lib) {
    DumpContext ctx(std::cout);
    obj_lib.dump(ctx);
    std::exit(EXIT_SUCCESS);
}
