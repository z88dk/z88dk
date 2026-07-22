//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "binary_data.h"
#include "binary_file.h"
#include "diag.h"
#include "obj_expr.h"
#include "obj_extern.h"
#include "obj_features.h"
#include "obj_modname.h"
#include "obj_module.h"
#include "obj_reader.h"
#include "obj_reloc.h"
#include "obj_schema.h"
#include "obj_section.h"
#include "obj_symbol.h"
#include "release_assert.h"
#include "strings.h"
#include <memory>
#include <string>
#include <utility>
#include <vector>

//-----------------------------------------------------------------------------
// Object/Library file lazy reader
//-----------------------------------------------------------------------------

std::unique_ptr<ModuleReader> read_module_file(std::string_view filename) {
    // create binary file
    auto file = std::make_shared<const BinaryFile>(filename);

    // read signature
    std::string_view signature = file->peek_string_view(0, SignatureSize);
    ObjFileType type = ObjFileType::None;
    int version = 0;
    if (!parse_signature(signature, type, version)) {
        fatal_error("invalid object or library file '" +
                    std::string(file->filename()) + "'");
    }

    // construct respective object
    switch (type) {
    case ObjFileType::Object:
        return std::make_unique<ObjReader>(file, 0, file->size());

    case ObjFileType::Library:
        return std::make_unique<LibReader>(file);

    default:
        release_assert(0);
        return nullptr;
    }
}

//-----------------------------------------------------------------------------
// Object file lazy reader
//-----------------------------------------------------------------------------

ObjReader::ObjReader(std::shared_ptr<const BinaryFile> file,
                     size_t base_offset, size_t object_size)
    : file_(std::move(file)), obj_schema_(file_, base_offset, object_size) {
    module_.cpu_id = obj_schema_.cpu_id;
    module_.swap_ixiy = obj_schema_.swap_ixiy;
    module_.base_address = obj_schema_.base_address;
}

ObjFileType ObjReader::type() const {
    return ObjFileType::Object;
}

std::shared_ptr<const BinaryFile> ObjReader::file() const {
    return file_;
}

const ObjSchema& ObjReader::obj_schema() const {
    return obj_schema_;
}

int ObjReader::version() const {
    return obj_schema_.version;
}

const StringsView& ObjReader::strings() {
    if (!strings_loaded_) {
        if (obj_features(version()).has_string_table) {
            strings_.unpack(file_, obj_schema_.strings.offset);
        }
        strings_loaded_ = true;
    }

    return strings_;
}

const ObjModuleView& ObjReader::module() {
    return module_;
}

const ObjModnameView& ObjReader::modname() {
    if (!module_.modname.loaded) {
        size_t ptr = obj_schema_.modname.offset;
        module_.modname.value.unpack(file_, version(), strings(), ptr);
        module_.modname.loaded = true;
    }

    return module_.modname.value;
}

const std::vector<ObjExprView>& ObjReader::exprs() {
    if (!module_.exprs.loaded) {
        if (obj_schema_.exprs.present) {
            size_t ptr = obj_schema_.exprs.offset;
            size_t end_offset = obj_schema_.exprs.offset +
                                obj_schema_.exprs.size;
            ObjExprView::unpack_exprs(file_, version(), strings(),
                                      ptr, end_offset,
                                      module_.exprs.value);
        }
        module_.exprs.loaded = true;
    }

    return module_.exprs.value;
}

const std::vector<ObjRelocView>& ObjReader::relocs() {
    if (!module_.relocs.loaded) {
        if (obj_schema_.relocs.present) {
            size_t ptr = obj_schema_.relocs.offset;
            size_t end_offset = obj_schema_.relocs.offset +
                                obj_schema_.relocs.size;
            ObjRelocView::unpack_relocs(file_, version(), strings(),
                                        ptr, end_offset,
                                        module_.relocs.value);
        }
        module_.relocs.loaded = true;
    }

    return module_.relocs.value;
}

const std::vector<ObjSymbolView>& ObjReader::symbols() {
    if (!module_.symbols.loaded) {
        if (obj_schema_.symbols.present) {
            size_t ptr = obj_schema_.symbols.offset;
            size_t end_offset = obj_schema_.symbols.offset +
                                obj_schema_.symbols.size;
            ObjSymbolView::unpack_symbols(file_, version(), strings(),
                                          ptr, end_offset,
                                          module_.symbols.value);
        }
        module_.symbols.loaded = true;
    }

    return module_.symbols.value;
}

const std::vector<ObjExternView>& ObjReader::externs() {
    if (!module_.externs.loaded) {
        if (obj_schema_.externs.present) {
            size_t ptr = obj_schema_.externs.offset;
            size_t end_offset = obj_schema_.externs.offset +
                                obj_schema_.externs.size;
            ObjExternView::unpack_externs(file_, version(), strings(),
                                          ptr, end_offset,
                                          module_.externs.value);
        }
        module_.externs.loaded = true;
    }

    return module_.externs.value;
}

const std::vector<ObjSectionView>& ObjReader::sections() {
    if (!module_.sections.loaded) {
        if (obj_schema_.sections.present) {
            size_t ptr = obj_schema_.sections.offset;
            size_t end_offset = obj_schema_.sections.offset +
                                obj_schema_.sections.size;
            ObjSectionView::unpack_sections(file_, version(), strings(),
                                            ptr, end_offset,
                                            module_.sections.value);
        }
        module_.sections.loaded = true;
    }

    return module_.sections.value;
}

ObjModule ObjReader::to_obj_module() {
    ObjModule out;

    out.cpu_id = obj_schema_.cpu_id;
    out.swap_ixiy = obj_schema_.swap_ixiy;
    out.base_address = obj_schema_.base_address;

    // load modname
    const auto& mod = modname();
    out.modname = mod; // uses Storage::from_view internally

    // load exprs
    for (const auto& e : exprs()) {
        out.exprs.push_back(e); // Storage::from_view handles conversion
    }

    // load relocs
    for (const auto& r : relocs()) {
        out.relocs.push_back(r);
    }

    // load symbols
    for (const auto& s : symbols()) {
        out.symbols.push_back(s);
    }

    // load externs
    for (const auto& ex : externs()) {
        out.externs.push_back(ex);
    }

    // load sections
    for (const auto& sec : sections()) {
        out.sections.push_back(sec);
    }

    return out;
}

void dump_module(DumpContext ctx, const ObjModule& mod) {
    ctx.line("ObjModule: " + std::string(mod.modname.name()));
    auto c = ctx.child();
    c.line("CPU: " + to_string(mod.cpu_id));
    if (mod.swap_ixiy) {
        c.line("Swap IX/IY: true");
    }
    if (mod.base_address == OrgSectionSplit) {
        c.line("Base address: section split");
    }
    else if (mod.base_address != OrgNotDefined) {
        c.line("Base address: " + int_to_hex(mod.base_address));
    }

    ObjExpr::dump_exprs(c, mod.exprs);
    ObjReloc::dump_relocs(c, mod.relocs);
    ObjSymbol::dump_symbols(c, mod.symbols);
    ObjExtern::dump_externs(c, mod.externs);
    ObjSection::dump_sections(c, mod.sections);
}

void dump_module_short(const ObjModule& mod) {
    std::cout << "  Name: " << mod.modname.name() << std::endl;
    if (mod.base_address != OrgNotDefined && mod.base_address != OrgSectionSplit) {
        std::cout << "  ORG:  " << int_to_hex(mod.base_address) << std::endl;
    }
    std::cout << "  CPU:  " << to_string(mod.cpu_id) << " ";
    if (mod.swap_ixiy) {
        std::cout << "(-IXIY)";
    }
    std::cout << std::endl;
    ObjSection::dump_sections_short(mod.sections);
    ObjSymbol::dump_symbols_short(mod.symbols);
    ObjExtern::dump_externs_short(mod.externs);
    ObjExpr::dump_exprs_short(mod.exprs);
    ObjReloc::dump_relocs_short(mod.relocs);
}

void pack_module(BinaryData& bin_data, const ObjModule& mod) {
    Strings strings;

    // mark the start for the relative pointers
    size_t base = bin_data.size();

    // add signature
    bin_data.put_string(obj_file_signature());

    // add CPU and IXIY
    bin_data.put_dword(static_cast<uint32_t>(mod.cpu_id));
    bin_data.put_dword(static_cast<uint32_t>(mod.swap_ixiy));

    // append placeholders for 6 pointers to file sections
    size_t header_ptr = bin_data.size();
    for (int i = 0; i < 7; i++) {
        bin_data.put_dword(OffsetNotPresent);
    }

    // write each of the sections and collect the addresses
    size_t exprs_ptr = ObjExpr::pack_exprs(bin_data, strings, mod.exprs);
    size_t relocs_ptr = ObjReloc::pack_relocs(bin_data, strings, mod.relocs);
    size_t symbols_ptr = ObjSymbol::pack_symbols(bin_data, strings, mod.symbols);
    size_t externs_ptr = ObjExtern::pack_externs(bin_data, strings, mod.externs);
    size_t modname_ptr = mod.modname.pack(bin_data, strings);
    size_t sections_ptr = ObjSection::pack_sections(bin_data, strings, mod.sections);
    size_t strings_ptr = bin_data.size();
    strings.pack(bin_data);

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
        static_cast<uint32_t>(calc_offset(modname_ptr, base)));
    bin_data.put_dword_at(ptr,
        static_cast<uint32_t>(calc_offset(exprs_ptr, base)));
    bin_data.put_dword_at(ptr,
        static_cast<uint32_t>(calc_offset(relocs_ptr, base)));
    bin_data.put_dword_at(ptr,
        static_cast<uint32_t>(calc_offset(symbols_ptr, base)));
    bin_data.put_dword_at(ptr,
        static_cast<uint32_t>(calc_offset(externs_ptr, base)));
    bin_data.put_dword_at(ptr,
        static_cast<uint32_t>(calc_offset(sections_ptr, base)));
    bin_data.put_dword_at(ptr,
        static_cast<uint32_t>(calc_offset(strings_ptr, base)));
}

//-----------------------------------------------------------------------------
// Library file lazy reader
//-----------------------------------------------------------------------------

LibReader::LibReader(std::shared_ptr<const BinaryFile> file)
    : file_(std::move(file)), lib_schema_(file_) {
}

ObjFileType LibReader::type() const {
	return ObjFileType::Library;
}

std::shared_ptr<const BinaryFile> LibReader::file() const {
	return file_;
}

const LibSchema& LibReader::lib_schema() const {
	return lib_schema_;
}

int LibReader::version() const {
	return lib_schema_.version;
}



const StringsView& LibReader::strings() {
    if (!strings_loaded_) {
        if (obj_features(version()).has_string_table) {
            strings_.unpack(file_, lib_schema_.strings.offset);
        }
        strings_loaded_ = true;
    }

    return strings_;
}

