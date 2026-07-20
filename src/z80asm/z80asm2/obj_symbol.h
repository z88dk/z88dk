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
#include "obj_symbol_scope.h"
#include "obj_symbol_type.h"
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
// Symbol type
//-----------------------------------------------------------------------------

template <typename Storage>
struct ObjSymbolBase : public TreeNode {
    using Str = typename Storage::Str;

    // attributes
    Str name_;
    Str file_;
    uint line = 0;

    ObjSymbolScope scope = ObjSymbolScope::Undefined;
    ObjSymbolType type = ObjSymbolType::Undefined;

    int value;
    Str section_name_;

    // constructors
    ObjSymbolBase() = default;
    virtual ~ObjSymbolBase() = default;

    // Conversion constructor: only enabled when Storage == InternedStorage
    template <typename S = Storage, typename = EnableInterned<S>> ObjSymbolBase(
        const ObjSymbolBase<S>& other)
        : name_(other.name_),
          file_(g_strings.intern(other.file_)),
          line(other.line),
          scope(other.scope),
          type(other.type),
          value(other.value),
          section_name_(g_strings.intern(other.section_name_)) {}

    std::string_view name_view() const {
        return Storage::to_view(name_);
    }

    void set_name(std::string_view s) {
        name_ = Storage::from_view(s);
    }

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

    // dump method
    void dump(DumpContext ctx) const override {
        ctx.line("ObjSymbol: " + std::string(name_view()));
        DumpContext child_ctx = ctx.child();
        child_ctx.line("Name: " + escape_string(name_view()));
        SourceLoc loc(file_view(), line, 1);
        child_ctx.line("Location: " + loc.to_string());
        child_ctx.line("Scope: " + to_string(scope));
        child_ctx.line("Type: " + to_string(type));
        child_ctx.line("Value: " + int_to_hex(value));
        if (!section_name_view().empty()) {
            child_ctx.line("Section: " + std::string(section_name_view()));
        }
    }

    static void dump_symbols(DumpContext ctx,
        const std::vector<std::unique_ptr<ObjSymbolBase>>& symbols) {
        if (!symbols.empty()) {
            ctx.line("Symbols:");
            DumpContext child_ctx = ctx.child();
            for (auto& symbol : symbols) {
                symbol->dump(child_ctx);
            }
        }
    }

    void dump_short() const {
        std::cout << "    " << to_short_string(scope)
            << " " << to_short_string(type)
            << " " << int_to_hex(value)
            << ": " << name_view()
            << " (section ";
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

    static void dump_symbols_short(const std::vector<std::unique_ptr<ObjSymbolBase>>& symbols) {
        if (!symbols.empty()) {
            std::cout << "  Symbols:" << std::endl;
            for (auto& symbol : symbols) {
                symbol->dump_short();
            }
        }
    }

    // pack/unpack to/from binary data
    void pack(BinaryData& bytes, Strings& strings) const {
        bytes.put_dword(static_cast<uint32_t>(scope));
        bytes.put_dword(static_cast<uint32_t>(type));

        uint section_name_id = strings.intern(section_name_view());
        bytes.put_dword(static_cast<uint32_t>(section_name_id));

        bytes.put_dword(static_cast<uint32_t>(value));

        uint name_id = strings.intern(name_view());
        bytes.put_dword(static_cast<uint32_t>(name_id));

        uint file_id = strings.intern(file_view());
        bytes.put_dword(static_cast<uint32_t>(file_id));
        bytes.put_dword(static_cast<uint32_t>(line));
    }

    static size_t pack_symbols(BinaryData& bytes, Strings& strings,
        const std::vector<std::unique_ptr<ObjSymbolBase>>& symbols) {
        if (symbols.empty()) {
            return OffsetNotPresent;
        }

        size_t start_offset = bytes.size();
        for (auto& sym : symbols) {
            sym->pack(bytes, strings);
        }

        // end marker
        bytes.put_dword(0);

        return start_offset;
    }

    bool unpack(std::shared_ptr<const BinaryFile> file, int version,
        const StringsView& strings, size_t& ptr) {

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

        // value
        value = static_cast<int32_t>(file->get_dword(ptr));

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

        // definition location
        if (obj_features(version).has_symbol_file_line) {
            if (obj_features(version).has_string_table) {
                uint file_id = file->get_dword(ptr);
                set_file(strings.view(file_id));
            }
            else if (obj_features(version).has_word_strings) {
                std::string_view filename = file->get_word_string_view(ptr);
                set_file(filename);
            }
            else {
                std::string_view filename = file->get_byte_string_view(ptr);
                set_file(filename);
            }

            line = file->get_dword(ptr);
        }

        return true;
    }

    static void unpack_symbols(std::shared_ptr<const BinaryFile> file, int version,
        const StringsView& strings, size_t& ptr, size_t end_ptr,
        std::vector<ObjSymbolBase>& symbols) {
        symbols.clear();
        while (ptr < end_ptr) {
            ObjSymbolBase symbol;
            if (!symbol.unpack(file, version, strings, ptr)) {
                break; // end of symbols
            }
            symbols.push_back(symbol);
        }
    }
};

using ObjSymbolView = ObjSymbolBase<ViewStorage>;
using ObjSymbol = ObjSymbolBase<InternedStorage>;
