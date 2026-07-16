//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "binary_data.h"
#include "binary_file.h"
#include "diag.h"
#include "obj_features.h"
#include "obj_reader.h"
#include "release_assert.h"
#include "strings.h"
#include <memory>
#include <string>
#include <utility>
#include <vector>

#if 0
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
    : obj_schema_(file, base_offset, object_size) {
    module_.cpu_id = obj_schema_.cpu_id;
    module_.swap_ixiy = obj_schema_.swap_ixiy;
    module_.base_address = obj_schema_.base_address;
}

const StringTable& ObjReader::strings() {
    if (!strings_loaded_) {
        if (obj_features(version()).has_string_table) {
            strings_.unpack(file(), obj_schema_.strings.offset);
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
        module_.modname.value.unpack(file(), version(), strings(), ptr);
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
            ObjExprView::unpack_exprs(file(), version(), strings(),
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
            ObjRelocView::unpack_relocs(file(), version(), strings(),
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
            ObjSymbolView::unpack_symbols(file(), version(), strings(),
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
            ObjExternView::unpack_externs(file(), version(), strings(),
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
            ObjSectionView::unpack_sections(file(), version(), strings(),
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

//-----------------------------------------------------------------------------
// Library file lazy reader
//-----------------------------------------------------------------------------

LibReader::LibReader(std::shared_ptr<const BinaryFile> file)
    : lib_schema_(file) {
}

const StringTable& LibReader::strings() {
    if (!strings_loaded_) {
        if (obj_features(version()).has_string_table) {
            release_assert(lib_schema_.strings.present);
            strings_.unpack(file(), lib_schema_.strings.offset);
        }
        strings_loaded_ = true;
    }

    return strings_;
}

const SymbolIndex& LibReader::symbol_index() {
    if (!symbol_index_loaded_) {
        load_symbol_index();
        symbol_index_loaded_ = true;
    }

    return symbol_index_;
}

void LibReader::load_symbol_index() {
    symbol_index_.clear();

    if (obj_features(version()).has_symbol_index) {
        release_assert(lib_schema_.symbol_index.present);
        size_t cpu_ptr = lib_schema_.symbol_index.offset;
        auto f = file();
        auto st = strings();
        while (true) {
            // get next CPU
            CPU cpu_id = static_cast<CPU>(f->get_dword(cpu_ptr));
            if (cpu_id == CPU::none) {
                break;		// terminator
            }
            bool swap_ixiy = !!f->get_dword(cpu_ptr);

            size_t table_ptr = f->get_dword(cpu_ptr);
            size_t table_size = f->get_dword(cpu_ptr);

            CpuKey cpu_key = {cpu_id, swap_ixiy};
            auto cpu_table = symbol_index_[cpu_key];

            // read table
            for (size_t i = 0; i < table_size; i++) {
                uint id = f->get_dword(table_ptr);
                std::string_view symbol = st.view(StringId(id));
                StringId symbol_id = g_strings.intern(symbol);
                size_t module_offset = f->get_dword(table_ptr);

                auto it = cpu_table.find(symbol_id);
                if (it == cpu_table.end()) {	// only register the first entry
                    cpu_table[symbol_id] = module_offset;
                }
            }
        }
    }
    else {
        build_symbol_index();
    }
}

void LibReader::build_symbol_index() {
}
#endif
