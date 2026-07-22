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
// Modname type
//-----------------------------------------------------------------------------

template <typename Storage>
struct ObjModnameBase : public TreeNode {
    using Str = typename Storage::Str;

    // attributes
    Str name_;

    // constructors
    ObjModnameBase() = default;
    virtual ~ObjModnameBase() = default;

    // Conversion constructor: only enabled when Storage == InternedStorage
    template <typename S = Storage, typename = EnableInterned<S>> ObjModnameBase(
        const ObjModnameBase<ViewStorage>& v)
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
        ctx.line("Module name: " + std::string(name()));
    }

    void dump_short() const {
        std::cout << "  Name: " << name() << std::endl;
    }

    // pack/unpack to/from binary data
    size_t pack(BinaryData& bin_data, Strings& strings) const {
        size_t start_offset = bin_data.size();
        uint name_id = strings.intern(name());
        bin_data.put_dword(static_cast<uint32_t>(name_id));
        return start_offset;
    }

    void unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringsView& strings, size_t& ptr) {
        // name
        if (obj_features(version).has_string_table) {
            uint name_id = file->get_dword(ptr);
            set_name(strings.view(name_id));
        }
        else if (obj_features(version).has_word_strings) {
            std::string_view name = file->get_word_string_view(ptr);
            set_name(name);
        }
        else {
            std::string_view name = file->get_byte_string_view(ptr);
            set_name(name);
        }
    }
};

using ObjModnameView = ObjModnameBase<ViewStorage>;
using ObjModname = ObjModnameBase<InternedStorage>;
