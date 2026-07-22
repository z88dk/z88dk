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
// Section type
//-----------------------------------------------------------------------------

template <typename Storage>
struct ObjSectionBase : public TreeNode {
    using Str = typename Storage::Str;
    using Bytes = typename Storage::Bytes;

    // attributes
    Str name_;
    uint base_address = OrgNotDefined;
    uint align = 1;
    Bytes bytes_;

    // constructors
    ObjSectionBase() = default;
    virtual ~ObjSectionBase() = default;

    // Conversion constructor: only enabled when Storage == InternedStorage
    template <typename S = Storage, typename = EnableInterned<S>> ObjSectionBase(
        const ObjSectionBase<ViewStorage>& v)
        : base_address(v.base_address),
          align(v.align) {
        set_name(v.name());
        set_bytes(v.bytes());
    }

    // accessors
    std::string_view name() const {
        return Storage::to_view(name_);
    }

    void set_name(std::string_view s) {
        name_ = Storage::from_view(s);
    }

    BytesView bytes() const {
        return Storage::to_view(bytes_);
    }

    void set_bytes(BytesView b) {
        bytes_ = Storage::from_view(b);
    }

    // dump method
    void dump(DumpContext ctx) const override {
        ctx.line("Section:");
        DumpContext child_ctx = ctx.child();
        child_ctx.line("Name: " + std::string(name()));
        child_ctx.line("ORG: " + int_to_hex(base_address));
        child_ctx.line("Align: " + std::to_string(align));

        const uint8_t* data = bytes().data();
        size_t size = bytes().size();
        std::string bytes_str = "Bytes (" + std::to_string(size) + "):";
        for (size_t i = 0; i < size; i++) {
            bytes_str += " " + int_to_hex(data[i]);
        }
        child_ctx.line(bytes_str);
    }

    static void dump_sections(DumpContext ctx,
                              const std::vector<ObjSectionBase>& sections) {
        if (!sections.empty()) {
            ctx.line("Sections:");
            DumpContext child_ctx = ctx.child();
            for (auto& section : sections) {
                section.dump(child_ctx);
            }
        }
    }

    void dump_short() const {
        std::cout << "  Section ";
        if (name().empty()) {
            std::cout << "\"\"";
        }
        else {
            std::cout << name();
        }
        std::cout << ": " << bytes().size() << " bytes";
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
        print_bytes();
    }

    static void dump_sections_short(const
                                    std::vector<ObjSectionBase>&
                                    sections) {
        if (!sections.empty()) {
            std::cout << "  Sections:" << std::endl;
            for (auto& section : sections) {
                section.dump_short();
            }
        }
    }

    // pack/unpack to/from binary data
    void pack(BinaryData& bin_data, Strings& strings) const {
        // size
        size_t size = bytes().size();
        bin_data.put_dword(static_cast<uint32_t>(size));

        // section name
        uint name_id = strings.intern(name());
        bin_data.put_dword(static_cast<uint32_t>(name_id));

        // org
        bin_data.put_dword(static_cast<uint32_t>(base_address));

        // align
        bin_data.put_dword(static_cast<uint32_t>(align));

        // bytes
        bin_data.put_data(bytes().data(), size);

        // align
        bin_data.align(4);
    }

    static size_t pack_sections(BinaryData& bin_data, Strings& strings,
                                const std::vector<ObjSectionBase>& sections) {
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

    bool unpack(std::shared_ptr<const BinaryFile> file, int version,
                const StringsView& strings, size_t& ptr) {
        if (obj_features(version).has_sections) {
            // size
            size_t size = file->get_dword(ptr);
            if (size == OffsetNotPresent) {
                return false;	// end terminator
            }

            // section
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
            set_bytes(BytesView(file->get_data(ptr, size), size));

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
            set_bytes(BytesView(file->get_data(ptr, size), size));
        }

        return true;
    }

    static void unpack_sections(std::shared_ptr<const BinaryFile> file, int version,
                                const StringsView& strings, size_t& ptr, size_t end_ptr,
                                std::vector<ObjSectionBase>& sections) {
        sections.clear();
        while (ptr < end_ptr) {
            ObjSectionBase section;
            if (!section.unpack(file, version, strings, ptr)) {
                break; // end of sections
            }
            sections.push_back(section);
        }
    }

private:
    void print_bytes() const {
        bool need_nl = false;
        for (size_t addr = 0; addr < bytes().size(); addr++) {
            if ((addr % 16) == 0) {
                if (need_nl) {
                    std::cout << std::endl;
                    need_nl = false;
                }
                std::cout << "    C $"
                          << std::uppercase << std::hex
                          << std::setfill('0') << std::setw(4)
                          << addr
                          << std::nouppercase << std::dec
                          << std::setfill(' ')
                          << ":";
                need_nl = true;
            }

            std::cout << " "
                      << std::uppercase << std::hex
                      << std::setfill('0') << std::setw(2)
                      << bytes().data()[addr]
                      << std::nouppercase << std::dec
                      << std::setfill(' ');
            need_nl = true;
        }

        if (need_nl) {
            std::cout << std::endl;
            need_nl = false;
        }
    }
};


using ObjSectionView = ObjSectionBase<ViewStorage>;
using ObjSection = ObjSectionBase<InternedStorage>;
