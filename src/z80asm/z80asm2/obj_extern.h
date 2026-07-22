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
#include "obj_schema.h"
#include "source_loc.h"
#include "strings.h"
#include <cstdint>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

//-----------------------------------------------------------------------------
// Extern type
//-----------------------------------------------------------------------------

template <typename Storage>
struct ObjExternBase : public TreeNode {
    using Str = typename Storage::Str;

    // attributes
    Str name_;

    // constructors
    ObjExternBase() = default;
    virtual ~ObjExternBase() = default;

    // Conversion constructor: only enabled when Storage == InternedStorage
    template <typename S = Storage, typename = EnableInterned<S>> ObjExternBase(
        const ObjExternBase<ViewStorage>& v)
        : name_(g_strings.intern(v.name_)) {
    }

    // accessors
    std::string_view name() const {
        return Storage::to_view(name_);
    }

    void set_name(std::string_view s) {
        name_ = Storage::from_view(s);
    }

    // dump method
    void dump(DumpContext ctx) const override {
        ctx.line("Symbol: " + std::string(name()));
    }

    static void dump_externs(DumpContext ctx,
                             const std::vector<ObjExternBase>& externs) {
        if (!externs.empty()) {
            ctx.line("Externs:");
            DumpContext child_ctx = ctx.child();
            for (auto& extern_ : externs) {
                extern_.dump(child_ctx);
            }
        }
    }

    void dump_short() const {
        std::cout << "    U         " << name() << std::endl;
    }

    static void dump_externs_short(const std::vector<ObjExternBase>& externs) {
        if (!externs.empty()) {
            std::cout << "  Externs:" << std::endl;
            for (auto& extern_ : externs) {
                extern_.dump_short();
            }
        }
    }

    // pack/unpack to/from binary data
    void pack(BinaryData& bin_data, Strings& strings) const {
        uint name_id = strings.intern(name());
        bin_data.put_dword(static_cast<uint32_t>(name_id));
    }

    static size_t pack_externs(BinaryData& bin_data, Strings& strings,
                               const std::vector<ObjExternBase>& externs) {
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

    bool unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringsView& strings, size_t& ptr) {
        // name
        if (obj_features(version).has_string_table) {
            uint name_id = file->get_dword(ptr);
            if (name_id == 0) {
                return false;	// end marker
            }
            set_name(strings.view(name_id));
        }
        else if (obj_features(version).has_word_strings) {
            std::string_view name = file->get_word_string_view(ptr);
            if (name.empty()) {
                return false;	// end marker
            }
            set_name(name);
        }
        else {
            std::string_view name = file->get_byte_string_view(ptr);
            if (name.empty()) {
                return false;	// end marker
            }
            set_name(name);
        }

        return true;
    }

    static void unpack_externs(std::shared_ptr<const BinaryFile> file, int version,
                               const StringsView& strings, size_t& ptr, size_t end_ptr,
                               std::vector<ObjExternBase>& externs) {
        externs.clear();
        while (ptr < end_ptr) {
            ObjExternBase extern_;
            if (!extern_.unpack(file, version, strings, ptr)) {
                break; // end of externs
            }
            externs.push_back(extern_);
        }
    }
};

using ObjExternView = ObjExternBase<ViewStorage>;
using ObjExtern = ObjExternBase<InternedStorage>;
