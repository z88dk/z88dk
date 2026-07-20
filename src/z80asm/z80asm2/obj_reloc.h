//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_data.h"
#include "binary_file.h"
#include "diag.h"
#include "dump_context.h"
#include "obj_features.h"
#include "obj_format.h"
#include "obj_range_type.h"
#include "source_loc.h"
#include "strings.h"
#include <cstdint>
#include <iomanip>
#include <ios>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

//-----------------------------------------------------------------------------
// Relocation type
//-----------------------------------------------------------------------------

template <typename Storage>
struct ObjRelocBase : public TreeNode {
    using Str = typename Storage::Str;

    // attributes
    ObjRangeType range = ObjRangeType::Undefined;
    Str file_;
    uint line = 0;

    Str section_name_;
    uint patch_ptr = 0;

    Str symbol_;
    int addend = 0;				// Note: signed value

    // constructors
    ObjRelocBase() = default;
    virtual ~ObjRelocBase() = default;

    // Conversion constructor: only enabled when Storage == InternedStorage
    template <typename S = Storage, typename = EnableInterned<S>> ObjRelocBase(
        const ObjRelocBase<ViewStorage>& v)
        : range(v.range),
          file_(g_strings.intern(v.file_)),
          line(v.line),
          section_name_(g_strings.intern(v.section_name_)),
          patch_ptr(v.patch_ptr),
          symbol_(g_strings.intern(v.symbol_)),
          addend(v.addend) {
    }

    // accessors
    std::string_view file_view() const {
        return Storage::to_view(file_);
    }

    void set_file(std::string_view s) {
        file_ = Storage::from_view(s);
    }

    std::string_view section_name_view() const {
        return Storage::to_view(section_name_);
    }

    void set_section_name(std::string_view s) {
        section_name_ = Storage::from_view(s);
    }

    std::string_view symbol_view() const {
        return Storage::to_view(symbol_);
    }

    void set_symbol(std::string_view s) {
        symbol_ = Storage::from_view(s);
    }

    // dump method
    void dump(DumpContext ctx) const override {
        ctx.line("ObjReloc:");
        DumpContext child_ctx = ctx.child();
        SourceLoc loc(file_view(), line, 1);
        child_ctx.line("Location: " + loc.to_string());
        if (!section_name_view().empty()) {
            child_ctx.line("Section: " + std::string(section_name_view()));
        }
        child_ctx.line("Patch ptr: " + int_to_hex(patch_ptr));
        child_ctx.line("Range: " + to_string(range));
        child_ctx.line("Symbol: " + std::string(symbol_view()));
        child_ctx.line("Addend: " + int_to_hex(addend));
    }

    static void dump_relocs(DumpContext ctx,
                            const std::vector<std::unique_ptr<ObjRelocBase>>& relocs) {
        if (!relocs.empty()) {
            ctx.line("Relocations:");
            DumpContext child_ctx = ctx.child();
            for (auto& reloc : relocs) {
                reloc->dump(child_ctx);
            }
        }
    }

    void dump_short() const {
        std::cout << "    R "
                  << std::left << std::setw(5) << to_short_string(range)
                  << std::right
                  << " " << int_to_hex(patch_ptr)
                  << ": " << symbol_view() << "+" << int_to_hex(addend);
        std::cout << " (section ";
        if (section_name_view().empty()) {
            std::cout << "\"\"";
        }
        else {
            std::cout << section_name_view();
        }
        std::cout << ")"
                  << " (file ";
        if (file_view().empty()) {
            std::cout << "\"\"";
        }
        else {
            std::cout << file_view();
        }
        std::cout << ":" << line << ")" << std::endl;
    }

    static void dump_relocs_short(const std::vector<std::unique_ptr<ObjRelocBase>>&
                                  relocs) {
        if (!relocs.empty()) {
            std::cout << "  Relocations:" << std::endl;
            for (auto& reloc : relocs) {
                reloc->dump_short();
            }
        }
    }

    // pack/unpack to/from binary data
    void pack(BinaryData& bytes, Strings& strings) const {
        bytes.put_dword(static_cast<uint32_t>(range));

        uint file_id = strings.intern(file_view());
        bytes.put_dword(static_cast<uint32_t>(file_id));
        bytes.put_dword(static_cast<uint32_t>(line));

        uint section_name_id = strings.intern(section_name_view());
        bytes.put_dword(static_cast<uint32_t>(section_name_id));

        bytes.put_dword(static_cast<uint32_t>(patch_ptr));

        uint symbol_id = strings.intern(symbol_view());
        bytes.put_dword(static_cast<uint32_t>(symbol_id));

        bytes.put_dword(static_cast<uint32_t>(addend));
    }

    static size_t pack_relocs(BinaryData& bytes, Strings& strings,
                              const std::vector<std::unique_ptr<ObjRelocBase>>& relocs) {
        if (relocs.empty()) {
            return OffsetNotPresent;
        }

        size_t start_offset = bytes.size();
        for (auto& reloc : relocs) {
            reloc->pack(bytes, strings);
        }

        // end marker
        bytes.put_dword(0);

        return start_offset;
    }

    bool unpack(std::shared_ptr<const BinaryFile> file, int /*version*/,
                const StringsView& strings, size_t& ptr) {
        // get range type
        range = static_cast<ObjRangeType>(file->get_dword(ptr));
        if (range == ObjRangeType::Undefined) {
            return false; // end of relocations
        }

        // filename and line number
        uint filename_id = file->get_dword(ptr);
        set_file(strings.view(filename_id));
        line = file->get_dword(ptr);

        // section
        uint section_name_id = file->get_dword(ptr);
        set_section_name(strings.view(section_name_id));

        // patch pointer
        patch_ptr = file->get_dword(ptr);

        // symbol
        uint symbol_id = file->get_dword(ptr);
        set_symbol(strings.view(symbol_id));

        // addend
        addend = static_cast<int32_t>(file->get_dword(ptr));

        return true;
    }

    static void unpack_relocs(std::shared_ptr<const BinaryFile> file, int version,
                              const StringsView& strings, size_t& ptr, size_t end_ptr,
                              std::vector<ObjRelocBase>& relocs) {
        relocs.clear();
        while (ptr < end_ptr) {
            ObjRelocBase reloc;
            if (!reloc.unpack(file, version, strings, ptr)) {
                break; // end of relocations
            }
            relocs.push_back(reloc);
        }
    }

};

using ObjRelocView = ObjRelocBase<ViewStorage>;
using ObjReloc = ObjRelocBase<InternedStorage>;
