//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "strings.h"
#include <cstdint>
#include <vector>

using uint = unsigned int;

// memory range
struct MemRange {
    StringId name_id;
    uint address = 0;
    uint size = 0;
};

// memory bank - physical memory area to load modules
struct MemBank {
    MemRange range;                 // full size of block
    std::vector<MemRange> exclude;  // hardware holes or reserved addresses
};

// memory page
struct MemPage {
    StringId name_id;          // PAGE0, PAGE1, etc.
    StringId bank_name_id;     // which bank this page maps into
};

// section pattern: pattern with '*' and '?'for wildcard matching of section names
struct SectionPattern {
    StringId pattern_id;

    bool matches(StringId section_name_id) const;
};

// conpression of a group and expansion in runtime
struct MemCompression {
    StringId stored_as_group_name_id;   // compressed group name
    StringId compresser_tool_name_id;   // external compressor executable
    StringId expander_name_id;          // Z80 routine symbol name
    uint expanded_address;              // address after decompression
};

// named goups of sections to be placed in a memory bank
struct MemGroup {
    StringId name_id;
    uint max_size = 0;  // maximum size of group, 0 = no limit
    std::vector<SectionPattern> section_patterns;

    bool compressed = false;
    MemCompression compression; // valid only if compressed == true
};

// placement of a memory group in a memory bank
struct MemAbsolutePlacement {
    uint address = 0;           // absolute address to place the group
};

struct MemPlacement {
    enum class PlacementType {
        Absolute,   // absolute placement at memory address
        Within,     // absolute placement within a specific range
        InBank,     // placement in bank at next available address
        AfterGroup, // placement after previous group in bank
    } type = PlacementType::Absolute;

    StringId group_name_id;

    uint align = 1;             // alignment for placement
    uint8_t filler_byte = 0;    // filler byte for alignment

    // optional: place group in a specific page
    StringId page_name_id;

    // for Absolute placement, the absolute address to place the group
    uint absolute_address = 0;
    uint absolute_max_size = 0; // max size, 0 = no limit

    // for Within placement, the range to place the group within
    uint within_address = 0;
    uint within_size = 0;       // max size, 0 = no limit

    // for InBank placement, the bank to place the group in
    StringId bank_name_id;

    // for AfterGroup, the group to place this group after
    StringId after_group_name_id;
};

// symbol to be created after linking, with a specific address
struct MemSymbol {
    StringId name_id;

    // for bank symbols
    StringId bank_name_id; // bank where symbol is located

    // for group symbols
    StringId group_name_id; // group where symbol is located

    enum class BaseType {
        Start,      // start of group or bank
        End,        // end of group or bank
    };

    BaseType base_type = BaseType::Start;
    int offset = 0;      // offset from base address
};

// memory map: list of banks, groups, and placements
struct MemMap {
    std::vector<MemBank> banks;
    std::vector<MemPage> pages;
    std::vector<MemGroup> groups;
    std::vector<MemPlacement> placements;
    std::vector<MemSymbol> symbols;

    // find bank by name, return nullptr if not found
    const MemBank* find_bank(StringId bank_name_id) const;

    // find group by name, return nullptr if not found
    const MemGroup* find_group(StringId group_name_id) const;
};
