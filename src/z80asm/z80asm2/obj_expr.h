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
#include "obj_range_type.h"
#include "obj_schema.h"
#include "source_loc.h"
#include "string_utils.h"
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
// Expression type
//-----------------------------------------------------------------------------

template <typename Storage>
struct ObjExprBase : public TreeNode {
    using Str = typename Storage::Str;

    // attributes
    ObjRangeType range = ObjRangeType::Undefined;
    Str filename_;
    uint line = 0;

    Str section_name_;
    uint asmpc = 0;
    uint patch_ptr = 0;
    uint opcode_size = 0;

    Str target_name_;
    Str text_;

    // constructors
    ObjExprBase() = default;
    virtual ~ObjExprBase() = default;

    // Conversion constructor: only enabled when Storage == InternedStorage
    template <typename S = Storage, typename = EnableInterned<S>> ObjExprBase(
        const ObjExprBase<ViewStorage>& v)
        : range(v.range),
          filename_(g_strings.intern(v.filename_)),
          line(v.line),
          section_name_(g_strings.intern(v.section_name_)),
          asmpc(v.asmpc),
          patch_ptr(v.patch_ptr),
          opcode_size(v.opcode_size),
          target_name_(g_strings.intern(v.target_name_)),
          text_(g_strings.intern(v.text_)) {
    }

    // accessors
    std::string_view filename() const {
        return Storage::to_view(filename_);
    }

    void set_filename(std::string_view s) {
        filename_ = Storage::from_view(s);
    }

    std::string_view section_name() const {
        return Storage::to_view(section_name_);
    }

    void set_section_name(std::string_view s) {
        section_name_ = Storage::from_view(s);
    }

    std::string_view target_name() const {
        return Storage::to_view(target_name_);
    }

    void set_target_name(std::string_view s) {
        target_name_ = Storage::from_view(s);
    }

    std::string_view text() const {
        return Storage::to_view(text_);
    }

    void set_text(std::string_view s) {
        text_ = Storage::from_view(s);
    }

    // dump method
    void dump(DumpContext ctx) const override {
        ctx.line("ObjExpr:");
        DumpContext child_ctx = ctx.child();
        SourceLoc loc(filename(), line, 1);
        child_ctx.line("Location: " + loc.to_string());
        child_ctx.line("Text: " + escape_string(text()));
        child_ctx.line("Range: " + to_string(range));
        child_ctx.line("ASMPC: " + int_to_hex(asmpc));
        child_ctx.line("Patch ptr: " + int_to_hex(patch_ptr));
        child_ctx.line("Opcode size: " + int_to_hex(opcode_size));
        if (!section_name().empty()) {
            child_ctx.line("Section: " + std::string(section_name()));
        }
        if (!target_name().empty()) {
            child_ctx.line("Target: " + std::string(target_name()));
        }
    }

    static void dump_exprs(DumpContext ctx,
                           const std::vector<ObjExprBase>& exprs) {
        if (!exprs.empty()) {
            ctx.line("Expressions:");
            DumpContext child_ctx = ctx.child();
            for (auto& expr : exprs) {
                expr.dump(child_ctx);
            }
        }
    }

    void dump_short() const {
        std::cout << "    E "
                  << std::left << std::setw(5) << to_short_string(range)
                  << std::right
                  << " " << int_to_hex(asmpc)
                  << " " << int_to_hex(patch_ptr)
                  << " " << opcode_size
                  << ": ";
        if (!target_name().empty()) {
            std::cout << target_name() << " := ";
        }
        std::cout << text()
                  << " (section ";
        if (section_name().empty()) {
            std::cout << "\"\"";
        }
        else {
            std::cout << section_name();
        }
        std::cout << ")"
                  << " (file ";
        if (filename().empty()) {
            std::cout << "\"\"";
        }
        else {
            std::cout << filename();
        }
        std::cout << ":" << line << ")" << std::endl;
    }

    static void dump_exprs_short(const std::vector<ObjExprBase>& exprs) {
        if (!exprs.empty()) {
            std::cout << "  Expressions:" << std::endl;
            for (auto& expr : exprs) {
                expr.dump_short();
            }
        }
    }

    // pack/unpack to/from binary data
    void pack(BinaryData& bin_data, Strings& strings) const {
        bin_data.put_dword(static_cast<uint32_t>(range));

        uint filename_id = strings.intern(filename());
        bin_data.put_dword(static_cast<uint32_t>(filename_id));
        bin_data.put_dword(static_cast<uint32_t>(line));

        uint section_name_id = strings.intern(section_name());
        bin_data.put_dword(static_cast<uint32_t>(section_name_id));

        bin_data.put_dword(static_cast<uint32_t>(asmpc));
        bin_data.put_dword(static_cast<uint32_t>(patch_ptr));
        bin_data.put_dword(static_cast<uint32_t>(opcode_size));

        uint target_name_id = strings.intern(target_name());
        bin_data.put_dword(static_cast<uint32_t>(target_name_id));

        uint text_id = strings.intern(text());
        bin_data.put_dword(static_cast<uint32_t>(text_id));
    }

    static size_t pack_exprs(BinaryData& bin_data, Strings& strings,
                             const std::vector<ObjExprBase>& exprs) {
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

    bool unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringsView& strings, size_t& ptr, std::string_view& last_filename) {
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
            uint filename_id = file->get_dword(ptr);
            set_filename(strings.view(filename_id));
            line = file->get_dword(ptr);
        }
        else if (obj_features(version).has_expr_file_line) {
            std::string_view filename = file->get_word_string_view(ptr);
            set_filename(filename);
            line = file->get_dword(ptr);

            if (filename.empty()) {
                filename = last_filename;
            }
            else {
                last_filename = filename;
            }
        }

        // section
        if (obj_features(version).has_sections) {
            if (obj_features(version).has_string_table) {
                uint section_name_id = file->get_dword(ptr);
                set_section_name(strings.view(section_name_id));
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
                uint target_name_id = file->get_dword(ptr);
                set_target_name(strings.view(target_name_id));
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
            uint text_id = file->get_dword(ptr);
            set_text(strings.view(text_id));
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

    static void unpack_exprs(std::shared_ptr<const BinaryFile> file, int version,
                             const StringsView& strings, size_t& ptr, size_t end_ptr,
                             std::vector<ObjExprBase>& exprs) {
        exprs.clear();

        // reuse filename for consecutive expressions with same file
        std::string_view last_filename;
        while (ptr < end_ptr) {
            ObjExprBase expr;
            if (!expr.unpack(file, version, strings, ptr, last_filename)) {
                break; // end of expressions
            }
            exprs.push_back(expr);
        }
    }
};

using ObjExprView = ObjExprBase<ViewStorage>;
using ObjExpr = ObjExprBase<InternedStorage>;
