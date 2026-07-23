//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "diag.h"
#include "lexer_keywords.h"
#include "release_assert.h"
#include "string_utils.h"
#include "strings.h"
#include <algorithm>
#include <iterator>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

// CPU description
struct CpuLookup {
    uint id;                    // numeric value of CPU id
    CPU cpu_id;                 // cpu id
    std::string_view name_str;  // cpu name
    CPU non_strict;             // cpu id of non-strict version
    CPU compat_parent;          // cpu id of compatible parent
    std::string_view defines;   // space separated list of defines
};

// CPU description table, generated from cpu.def
static constexpr CpuLookup cpu_lookup_table[] = {
#define X(id, name, name_str, non_strict, ancestor, defines)	    \
    { id, CPU::name, name_str, CPU::non_strict, CPU::ancestor, defines },
#include "../cpu.def"
#undef X
};

// map CPU id to CPU description
static const std::unordered_map<CPU, const CpuLookup*> cpu_id_map = []() {
    std::unordered_map<CPU, const CpuLookup*> m;
    for (const auto& entry : cpu_lookup_table) {
        m[entry.cpu_id] = &entry;
    }
    return m;
}
();

// map CPU name to CPU description
static const std::unordered_map<std::string_view, const CpuLookup*> cpu_name_map
= []() {
    std::unordered_map<std::string_view, const CpuLookup*> m;
    for (const auto& entry : cpu_lookup_table) {
        m[entry.name_str] = &entry;
    }
    return m;
}
();

// get CPU name from CPU id
std::string to_string(CPU cpu_id) {
    return std::string(to_view(cpu_id));
}

std::string_view to_view(CPU cpu_id) {
    auto it = cpu_id_map.find(cpu_id);
    if (it == cpu_id_map.end()) {
        fatal_error("Unknown CPU id: " + std::to_string(static_cast<uint>(cpu_id)));
    }
    else {
        return it->second->name_str;
    }
}

// lookup CPU id from CPU name
bool cpu_lookup(std::string_view name, CPU& out_cpu_id) {
    auto it = cpu_name_map.find(name);
    if (it == cpu_name_map.end()) {
        return false;
    }
    else {
        out_cpu_id = it->second->cpu_id;
        return true;
    }
}

// return sorted list of CPU names
std::vector<std::string_view> cpu_names() {
    static const std::vector<std::string_view> names = []() {
        std::vector<std::string_view> m;
        for (auto& entry : cpu_lookup_table) {
            m.push_back(entry.name_str);
        }
        std::sort(m.begin(), m.end());
        return m;
    }
    ();
    return names;
}

// list of all unique defines for all CPUs
std::vector<std::string_view> cpu_all_defines() {
    static const std::vector<std::string_view> cpu_all_defines = []() {
        std::vector<std::string_view> m;
        for (const auto& entry : cpu_lookup_table) {
            for (auto& define : split_spaces(entry.defines)) {
                m.push_back(define);
            }
        }
        std::sort(m.begin(), m.end());
        m.erase(std::unique(m.begin(), m.end()), m.end());
        return m;
    }
    ();
    return cpu_all_defines;
}

// list of defines for each CPU
std::vector<std::string_view> cpu_defines(CPU cpu_id) {
    static const std::unordered_map<CPU, std::vector<std::string_view>>
    cpu_defines_table = []() {
        std::unordered_map<CPU, std::vector<std::string_view>> m;
        for (const auto& entry : cpu_lookup_table) {
            for (auto& define : split_spaces(entry.defines)) {
                m[entry.cpu_id].push_back(define);
            }
        }
        return m;
    }
    ();

    auto it = cpu_defines_table.find(cpu_id);
    if (it == cpu_defines_table.end()) {
        return {};
    }
    else {
        return it->second;
    }
}

// check if CPU is strict version
bool cpu_is_strict(CPU cpu_id) {
    auto it = cpu_id_map.find(cpu_id);
    if (it != cpu_id_map.end()) {
        return it->second->cpu_id == it->second->non_strict;
    }
    return false;
}

// return non-strict version of CPU id
CPU cpu_unstrictify(CPU cpu_id) {
    auto it = cpu_id_map.find(cpu_id);
    if (it != cpu_id_map.end()) {
        return it->second->non_strict;
    }
    return cpu_id;
}

// DFS post-order (children first -> parent last)
static void dfs_cpu(CPU cpu,
                    std::vector<CPU>& out,
                    std::unordered_set<CPU>& visited,
                    const std::unordered_map<CPU, std::vector<CPU>>& children) {
    if (visited.count(cpu)) {
        return;
    }

    visited.insert(cpu);

    auto it = children.find(cpu);
    if (it != children.end()) {
        for (CPU child : it->second) {
            dfs_cpu(child, out, visited, children);
        }
    }

    out.push_back(cpu);   // post-order: children first
}

std::vector<CPU> cpus_specific_to_general() {
    // Cache the result in a static variable
    static std::vector<CPU> cached_result;

    if (!cached_result.empty()) {
        return cached_result;
    }

    // build the list of children for each CPU
    std::unordered_map<CPU, std::vector<CPU>> children;
    for (const auto& entry : cpu_lookup_table) {
        CPU parent = entry.compat_parent;
        if (parent != CPU::none) {
            children[parent].push_back(entry.cpu_id);
        }
    }

    // Sort siblings by CPU ID to guarantee stable ordering
    for (auto& [parent, child_list] : children) {
        std::sort(child_list.begin(), child_list.end());
    }

    // run DFS from every CPU to get the post-order (children first -> parent last)
    cached_result.reserve(std::size(cpu_lookup_table));

    std::unordered_set<CPU> visited;

    // Run DFS from every CPU (forest)
    for (const auto& entry : cpu_lookup_table) {
        dfs_cpu(entry.cpu_id, cached_result, visited, children);
    }

    return cached_result;
}

bool cpu_compatible(CPU code_cpu_id, CPU lib_cpu_id) {
    code_cpu_id = cpu_unstrictify(code_cpu_id);
    lib_cpu_id = cpu_unstrictify(lib_cpu_id);

    CPU id = code_cpu_id;
    while (id != CPU::none) {
        if (id == lib_cpu_id) {
            return true;
        }
        else {
            auto it = cpu_id_map.find(id);
            release_assert(it != cpu_id_map.end());
            id = it->second->compat_parent;
        }
    }
    return false;
}

bool cpu_set_adl_mode(CPU& in_out_cpu_id, bool adl) {
    switch (in_out_cpu_id) {
    case CPU::ez80:
    case CPU::ez80_z80:
        in_out_cpu_id = adl ? CPU::ez80 : CPU::ez80_z80;
        return true;
    case CPU::ez80_strict:
    case CPU::ez80_z80_strict:
        in_out_cpu_id = adl ? CPU::ez80_strict : CPU::ez80_z80_strict;
        return true;
    default:
        return false;
    }
}

Keyword cpu_invert_flag_condition(Keyword kw) {
    switch (kw) {
    case Keyword::C:
        return Keyword::NC;
    case Keyword::EQ:
        return Keyword::NE;
    case Keyword::GE:
        return Keyword::LT;
    case Keyword::GEU:
        return Keyword::LTU;
    case Keyword::GT:
        return Keyword::LE;
    case Keyword::GTU:
        return Keyword::LEU;
    case Keyword::K:
        return Keyword::NK;
    case Keyword::LE:
        return Keyword::GT;
    case Keyword::LEU:
        return Keyword::GTU;
    case Keyword::LO:
        return Keyword::LZ;
    case Keyword::LT:
        return Keyword::GE;
    case Keyword::LTU:
        return Keyword::GEU;
    case Keyword::LZ:
        return Keyword::LO;
    case Keyword::M:
        return Keyword::P;
    case Keyword::NC:
        return Keyword::C;
    case Keyword::NE:
        return Keyword::EQ;
    case Keyword::NK:
        return Keyword::K;
    case Keyword::NV:
        return Keyword::V;
    case Keyword::NX5:
        return Keyword::X5;
    case Keyword::NZ:
        return Keyword::Z;
    case Keyword::P:
        return Keyword::M;
    case Keyword::PE:
        return Keyword::PO;
    case Keyword::PO:
        return Keyword::PE;
    case Keyword::V:
        return Keyword::NV;
    case Keyword::X5:
        return Keyword::NX5;
    case Keyword::Z:
        return Keyword::NZ;
    default:
        release_assert(0);
        return Keyword::None;
    }
}

// replace IX<->IY, IXH<->IYH, AIX<->AIY, XIX<->YIY
static void swap_x_y(std::string& inout_text) {
    for (auto& c : inout_text) {
        switch (c) {
        case 'x':
            c = 'y';
            break;
        case 'X':
            c = 'Y';
            break;
        case 'y':
            c = 'x';
            break;
        case 'Y':
            c = 'X';
            break;
        default:
            ;
        }
    }
}

void swap_ixiy(std::string& inout_text, Keyword& inout_kw) {
    if (keyword_is_x_register(inout_kw)) {
        swap_x_y(inout_text);
        inout_kw = keyword_lookup(inout_text);
    }
}

bool compute_z88_call_oz(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                         const std::vector<std::pair<int, SourceLoc>>& val_loc_data) {
    release_assert(val_loc_data.size() == 1);
    int arg_value = val_loc_data.front().first;
    SourceLoc expr_loc = val_loc_data.front().second;

    out_def_val_data.emplace_back(Keyword::RST, 0x20);
    if (arg_value >= 0 && arg_value <= 0xFF) {
        out_def_val_data.emplace_back(Keyword::DEFB, arg_value);
    }
    else if (arg_value >= 0x100 && arg_value <= 0xFFFF) {
        out_def_val_data.emplace_back(Keyword::DEFW, arg_value);
    }
    else {
        g_diag.error(expr_loc,
                     "Value out of range: " + int_to_hex(arg_value));
        return false;
    }

    return true;
}

bool compute_z88_call_pkg(std::vector<std::pair<Keyword, int>>&
                          out_def_val_data,
                          const std::vector<std::pair<int, SourceLoc>>& val_loc_data,
                          CPU cpu_id, Keyword kw, const SourceLoc& kw_loc) {
    release_assert(val_loc_data.size() == 1);
    int arg_value = val_loc_data.front().first;
    SourceLoc expr_loc = val_loc_data.front().second;

    // Rabbit's don't have RST $08
    if (cpu_id == CPU::r2ka || cpu_id == CPU::r2ka_strict ||
            cpu_id == CPU::r3k || cpu_id == CPU::r3k_strict ||
            cpu_id == CPU::r4k || cpu_id == CPU::r4k_strict ||
            cpu_id == CPU::r5k || cpu_id == CPU::r5k_strict ||
            cpu_id == CPU::r6k || cpu_id == CPU::r6k_strict) {
        g_diag.error(kw_loc,
                     to_string(kw) + " not supported on " + to_string(cpu_id));
        return false;
    }

    // check argument range
    if (arg_value < 0 || arg_value > 0xFFFF) {
        g_diag.error(expr_loc,
                     "Value out of range: " + int_to_hex(arg_value));
        return false;
    }

    out_def_val_data.emplace_back(Keyword::RST, 0x08);
    out_def_val_data.emplace_back(Keyword::DEFW, arg_value);

    return true;
}

bool compute_z88_fpp(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                     const std::vector<std::pair<int, SourceLoc>>& val_loc_data) {
    release_assert(val_loc_data.size() == 1);
    int arg_value = val_loc_data.front().first;
    SourceLoc expr_loc = val_loc_data.front().second;

    out_def_val_data.emplace_back(Keyword::RST, 0x18);
    if (arg_value >= -0x80 && arg_value <= 0xFF) {
        out_def_val_data.emplace_back(Keyword::DEFB, arg_value);
    }
    else {
        g_diag.error(expr_loc,
                     "Value out of range: " + int_to_hex(arg_value));
        return false;
    }

    return true;
}

bool compute_ti83_invoke_prefix(std::string& out_instr_prefix,
                                CPU cpu_id, Keyword kw, const SourceLoc& kw_loc) {
    if (cpu_id == CPU::ti83 || cpu_id == CPU::ti83_strict) {
        // TI83 uses CALL
        out_instr_prefix = "CALL";
        return true;
    }
    else if (cpu_id == CPU::ti83plus || cpu_id == CPU::ti83plus_strict) {
        // TI83+ uses RST $28
        out_instr_prefix = "RST $28 : DEFW";
        return true;
    }
    else {
        g_diag.error(kw_loc,
                     to_string(kw) + " not supported on " + to_string(cpu_id));
        return false;
    }
}

bool compute_z80n_cu_wait(std::vector<std::pair<Keyword, int>>& def_val_data,
                          CPU cpu_id, int ver, int hor,
                          const SourceLoc& kw_loc,
                          const SourceLoc& ver_loc,
                          const SourceLoc& hor_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, "CU_WAIT not supported on " + to_string(cpu_id));
        return false;
    }

    if (ver < 0 || ver > 311) {
        g_diag.error(ver_loc,
                     "Vertical value out of range in CU_WAIT: "
                     + int_to_hex(ver));
        return false;
    }

    if (hor < 0 || hor > 55) {
        g_diag.error(hor_loc,
                     "Horizontal value out of range in CU_WAIT: "
                     + int_to_hex(hor));
        return false;
    }

    int value = 0x8000 + (hor << 9) + ver;
    def_val_data.emplace_back(Keyword::DEFW_BE, value);
    return true;
}

bool compute_z80n_cu_move(std::vector<std::pair<Keyword, int>>& def_val_data,
                          CPU cpu_id, int reg, int val,
                          const SourceLoc& kw_loc,
                          const SourceLoc& reg_loc,
                          const SourceLoc& val_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, "CU_MOVE not supported on " + to_string(cpu_id));
        return false;
    }

    if (reg < 0 || reg > 127) {
        g_diag.error(reg_loc,
                     "Register value out of range in CU_MOVE: "
                     + int_to_hex(reg));
        return false;
    }

    if (val < -128 || val > 255) {
        g_diag.error(val_loc,
                     "Value out of range in CU_MOVE: "
                     + int_to_hex(val));
        return false;
    }

    int value = ((reg & 0x7f) << 8) | (val & 0xff);
    def_val_data.emplace_back(Keyword::DEFW_BE, value);
    return true;
}

bool compute_z80n_cu_stop(std::vector<std::pair<Keyword, int>>& def_val_data,
                          CPU cpu_id,
                          const SourceLoc& kw_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, "CU_STOP not supported on " + to_string(cpu_id));
        return false;
    }

    int value = 0xFFFF;
    def_val_data.emplace_back(Keyword::DEFW_BE, value);
    return true;
}

bool compute_z80n_cu_nop(std::vector<std::pair<Keyword, int>>& def_val_data,
                         CPU cpu_id, const SourceLoc& kw_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, "CU_NOP not supported on " + to_string(cpu_id));
        return false;
    }

    int value = 0x0000;
    def_val_data.emplace_back(Keyword::DEFW_BE, value);
    return true;
}

bool compute_z80n_dma(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                      CPU cpu_id,
                      const std::vector<std::pair<int, SourceLoc>>& val_loc_data,
                      Keyword kw,
                      const SourceLoc& kw_loc, const SourceLoc& eol_loc) {
    release_assert(!val_loc_data.empty());

    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, to_string(kw) + " not supported on " + to_string(cpu_id));
        return false;
    }

    // index into data
    size_t idx = 0;

    // Lambda to retrieve the last location from val_loc_data
    auto last_loc = [&]() -> SourceLoc {
        if (idx == 0) {
            return val_loc_data[0].second; // no values, use first loc for error
        }
        else if (idx <= val_loc_data.size()) {
            return val_loc_data[idx - 1].second; // last retrieved value loc
        }
        else {
            return val_loc_data.back().second; // all values retrieved, use last loc for error
        }
    };

    // Lambda to retrieve the next value from val_loc_data
    auto next_val = [&](int& out_value) -> bool {
        if (idx >= val_loc_data.size()) {
            g_diag.error(eol_loc,
                         "Missing value");
            return false;
        }
        out_value = val_loc_data[idx++].first;
        if (out_value < 0) {
            g_diag.error(last_loc(),
                         "Integer out of range: " + int_to_hex(out_value));
            return false;
        }
        return true;
    };

    // Lambda to create a new entry in out_size_val_data with the given size
    // and next value
    auto add_entry = [&](Keyword def) -> bool {
        int value = 0;
        if (!next_val(value)) {
            return false; // error already reported
        }
        out_def_val_data.emplace_back(def, value);
        return true;
    };

    // get command byte
    int N = 0, W = 0;
    if (!next_val(N)) {
        return false; // error already reported
    }

    switch (kw) {
    case Keyword::DMA_WR0:
        /*
        dma.wr0 n [, w, x, y, z]
        n: bit 7 must be 0, bits 1..0 must be 01 else error "Illegal base register"

        If bit 3 of n is set then accept one following byte\
        If bit 4 of n is set then accept one following byte/ set together, expect word instead
        If bit 5 of n is set then accept one following byte\
        If bit 6 of n is set then accept one following byte/ set together, expect word instead
        */
        if ((N & 0x83) != 0x01) {
            g_diag.error(last_loc(),
                         "Illegal base register: " + int_to_hex(N));
            return false;
        }

        // add command byte
        out_def_val_data.emplace_back(Keyword::DEFB, N & 0xFF);

        // parse wr0 parameters: check bits 3,4
        if ((N & 0x18) != 0 && idx >= val_loc_data.size()) {
            g_diag.error(eol_loc,
                         "Missing value");
            return false;
        }
        switch (N & 0x18) {
        case 0:
            break;
        case 0x08:	// bit 3
            if (!add_entry(Keyword::DEFB)) {
                return false;
            }
            break;
        case 0x10:	// bit 4
            if (!add_entry(Keyword::DEFB)) {
                return false;
            }
            break;
        case 0x18: 	// bits 3,4
            if (!add_entry(Keyword::DEFW)) {
                return false;
            }
            break;
        default:
            release_assert(0);
        }

        // parse wr0 parameters: check bits 5,6
        if ((N & 0x60) != 0 && idx >= val_loc_data.size()) {
            g_diag.error(eol_loc,
                         "Missing value");
            return false;
        }
        switch (N & 0x60) {
        case 0:
            break;
        case 0x20:	// bit 5
            if (!add_entry(Keyword::DEFB)) {
                return false;
            }
            break;
        case 0x40:	// bit 6
            if (!add_entry(Keyword::DEFB)) {
                return false;
            }
            break;
        case 0x60: 	// bits 5,6
            if (!add_entry(Keyword::DEFW)) {
                return false;
            }
            break;
        default:
            release_assert(0);
        }
        break;

    case Keyword::DMA_WR1:
        /*
        dma.wr1 n [,w]
        or 0x04 into n
        n: bit 7 must be 0, bits 2..0 must be 100 else error "Illegal base register"
        If bit 6 of n is set then accept one following byte w.

        In w bits 5..4 must be 0, bits 1..0 must not be 11 error "Illegal port A timing"
        In w if any of bits 7,6,3,2 are set warning "Half cycle timing not supported"
        */
        if (((N & 0x87) | 0x04) != 0x04) {
            g_diag.error(last_loc(),
                         "Illegal base register: " + int_to_hex(N));
            return false;
        }
        N |= 0x04;

        // add command byte
        out_def_val_data.emplace_back(Keyword::DEFB, N & 0xFF);

        if (N & 0x40) {
            if (idx >= val_loc_data.size()) {
                g_diag.error(eol_loc,
                             "Missing value");
                return false;
            }

            if (!next_val(W)) {
                return false; // error already reported
            }

            out_def_val_data.emplace_back(Keyword::DEFB, W & 0xFF);

            if ((W & 0x30) != 0 || (W & 0x03) == 0x03) {
                g_diag.error(last_loc(),
                             "Illegal port A timing: " + int_to_hex(W));
                return false;
            }
            if (W & 0xCC) {
                g_diag.warning(last_loc(),
                               "Half cycle timing not supported: " + int_to_hex(W));
            }
        }
        break;

    case Keyword::DMA_WR2:
        /*
        dma.wr2 n [,w,x]
        n: bit 7 must be 0, bits 2..0 must be 000 else error "Illegal base register"
        If bit 6 of n is set then accept one following byte w

        In w bit 4 must be 0, bits 1..0 must not be 11 error "Illegal port B timing"
        In w if any of bits 7,6,3,2 are set warning "Half cycle timing not supported"
        If bit 5 of w is set then accept one following byte x that can be anything.
        */
        if ((N & 0x87) != 0x00) {
            g_diag.error(last_loc(),
                         "Illegal base register: " + int_to_hex(N));
            return false;
        }

        // add command byte
        out_def_val_data.emplace_back(Keyword::DEFB, N & 0xFF);

        if (N & 0x40) {
            if (idx >= val_loc_data.size()) {
                g_diag.error(eol_loc,
                             "Missing value");
                return false;
            }

            if (!next_val(W)) {
                return false; // error already reported
            }

            out_def_val_data.emplace_back(Keyword::DEFB, W & 0xFF);

            if ((W & 0x10) != 0 || (W & 0x03) == 0x03) {
                g_diag.error(last_loc(),
                             "Illegal port B timing: " + int_to_hex(W));
                return false;
            }
            if (W & 0xCC) {
                g_diag.warning(last_loc(),
                               "Half cycle timing not supported: " + int_to_hex(W));
            }

            if (W & 0x20) {
                if (idx >= val_loc_data.size()) {
                    g_diag.error(eol_loc,
                                 "Missing value");
                    return false;
                }
                if (!add_entry(Keyword::DEFB)) {
                    return false;
                }
            }
        }
        break;

    case Keyword::DMA_WR3:
        /*
        dma.wr3 n [,w,x]
        or 0x80 into n
        n: bit 7 must be 1, bits 1..0 must be 00 else error "Illegal base register"
        If any of bits 6,5,2 of n are set then warning "Some DMA features not supported"

        If bit 3 of n is set then accept one following byte that can be anything.
        If bit 4 of n is set then accept one following byte that can be anything.
        */
        if (((N & 0x83) | 0x80) != 0x80) {
            g_diag.error(last_loc(),
                         "Illegal base register: " + int_to_hex(N));
            return false;
        }
        N |= 0x80;

        // add command byte
        out_def_val_data.emplace_back(Keyword::DEFB, N & 0xFF);

        if (N & 0x64) {
            g_diag.warning(last_loc(),
                           "Some DMA features not supported: " + int_to_hex(N));
        }

        if (N & 0x08) {
            if (idx >= val_loc_data.size()) {
                g_diag.error(eol_loc,
                             "Missing value");
                return false;
            }
            if (!add_entry(Keyword::DEFB)) {
                return false;
            }
        }

        if (N & 0x10) {
            if (idx >= val_loc_data.size()) {
                g_diag.error(eol_loc,
                             "Missing value");
                return false;
            }
            if (!add_entry(Keyword::DEFB)) {
                return false;
            }
        }
        break;

    case Keyword::DMA_WR4:
        /*
        dma.wr4 n, [w,x]
        or 0x81 into n
        n: bit 7 must be 1, bits 1..0 must be 01 else error "Illegal base register"
        If bit 4 of n is set then error "Interrupts not supported"
        If bits 6..5 of n are 00 or 11 error "dma mode is illegal"
        If bit 2 of n is set then accept one following byte\
        If bit 3 of n is set then accept one following byte/ set together, expect word instead

        Again if both bits 2 & 3 are set, w,x must be combined into a single word parameter.
        */
        if (((N & 0x83) | 0x81) != 0x81) {
            g_diag.error(last_loc(),
                         "Illegal base register: " + int_to_hex(N));
            return false;
        }
        if (N & 0x10) {
            g_diag.error(last_loc(),
                         "Interrupts not supported: " + int_to_hex(N));
            return false;
        }
        if ((N & 0x60) == 0 || (N & 0x60) == 0x60) {
            g_diag.error(last_loc(),
                         "Illegal mode: " + int_to_hex(N));
            return false;
        }
        N |= 0x81;

        // add command byte
        out_def_val_data.emplace_back(Keyword::DEFB, N & 0xFF);

        if ((N & 0x0C) == 0x0C) {
            if (idx >= val_loc_data.size()) {
                g_diag.error(eol_loc,
                             "Missing value");
                return false;
            }
            if (!add_entry(Keyword::DEFW)) {
                return false;
            }
        }
        else {
            if (N & 0x04) {
                if (idx >= val_loc_data.size()) {
                    g_diag.error(eol_loc,
                                 "Missing value");
                    return false;
                }
                if (!add_entry(Keyword::DEFB)) {
                    return false;
                }
            }
            if (N & 0x08) {
                if (idx >= val_loc_data.size()) {
                    g_diag.error(eol_loc,
                                 "Missing value");
                    return false;
                }
                if (!add_entry(Keyword::DEFB)) {
                    return false;
                }
            }
        }
        break;

    case Keyword::DMA_WR5:
        /*
        dma.wr5 n
        or 0x82 into n
        n: bits 7..6 must be 10, bits 2..0 must be 010 else error "Illegal base register"
        If bit 3 of n is set then warning "Ready signals not supported"
        */
        if (((N & 0xC7) | 0x82) != 0x82) {
            g_diag.error(last_loc(),
                         "Illegal base register: " + int_to_hex(N));
            return false;
        }
        N |= 0x82;

        if (N & 0x08) {
            g_diag.warning(last_loc(),
                           "Ready signals not supported: " + int_to_hex(N));
        }

        // add command byte
        out_def_val_data.emplace_back(Keyword::DEFB, N & 0xFF);

        break;

    case Keyword::DMA_WR6:
    case Keyword::DMA_CMD:
        /*
        dma.wr6 n [,w] or dma.cmd n [,w]
        n:
        accept 0xcf, 0xd3, 0x87, 0x83, 0xbb
        warning on 0xc3, 0xc7, 0xcb, 0xaf, 0xab, 0xa3, 0xb7, 0xbf, 0x8b, 0xa7, 0xb3
        "Command not implemented"
        anything else error "illegal dma command"

        if n = 0xbb accept a following byte w
        If bit 7 of w is set error "read mask is illegal"

        If any of these are missing following bytes in the comma list then maybe error
        "missing register group member(s)".
        if there are too many bytes "too many arguments".
        */
        switch (N) {
        case 0x83:
        case 0x87:
        case 0xBB:
        case 0xCF:
        case 0xD3:
            break;

        case 0x8B:
        case 0xA3:
        case 0xA7:
        case 0xAB:
        case 0xAF:
        case 0xB3:
        case 0xB7:
        case 0xBF:
        case 0xC3:
        case 0xC7:
        case 0xCB:
            g_diag.warning(last_loc(),
                           "Command not implemented: " + int_to_hex(N));
            break;

        default:
            g_diag.error(last_loc(),
                         "Illegal command: " + int_to_hex(N));
            return false;
        }

        // add command byte
        out_def_val_data.emplace_back(Keyword::DEFB, N & 0xFF);

        if (N == 0xBB) {
            if (idx >= val_loc_data.size()) {
                g_diag.error(eol_loc,
                             "Missing value");
                return false;
            }

            if (!next_val(W)) {
                return false; // error already reported
            }

            if (W & 0x80) {
                g_diag.error(last_loc(),
                             "Illegal mask" + int_to_hex(W));
                return false;
            }

            out_def_val_data.emplace_back(Keyword::DEFB, W & 0xFF);
        }
        break;

    default:
        release_assert(0);
        return false; // not reached
    }

    // Check for extra arguments
    if (idx < val_loc_data.size()) {
        g_diag.error(val_loc_data[idx].second,
                     "Too many arguments");
        return false;
    }

    return true;
}

bool compute_z80n_mmu_N(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                        CPU cpu_id, int slot, int page,
                        Keyword kw, const SourceLoc& kw_loc,
                        const SourceLoc& slot_loc, const SourceLoc& page_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, to_string(kw) + " not supported on " + to_string(cpu_id));
        return false;
    }

    if (slot < 0 || slot > 7) {
        g_diag.error(slot_loc, "Slot value out of range: " + int_to_hex(slot));
        return false;
    }

    if (page < 0 || page > 0xff) {
        g_diag.error(page_loc, "Page value out of range: " + int_to_hex(page));
        return false;
    }

    out_def_val_data.emplace_back(Keyword::DEFB, 0xED);
    out_def_val_data.emplace_back(Keyword::DEFB, 0x91);
    out_def_val_data.emplace_back(Keyword::DEFB, 0x50 | (slot & 0x07));
    out_def_val_data.emplace_back(Keyword::DEFB, (page & 0xFF));

    return true;
}

bool compute_z80n_mmu_A(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                        CPU cpu_id, int slot,
                        Keyword kw, const SourceLoc& kw_loc,
                        const SourceLoc& slot_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, to_string(kw) + " not supported on " + to_string(cpu_id));
        return false;
    }

    if (slot < 0 || slot > 7) {
        g_diag.error(slot_loc, "Slot value out of range: " + int_to_hex(slot));
        return false;
    }

    out_def_val_data.emplace_back(Keyword::DEFB, 0xED);
    out_def_val_data.emplace_back(Keyword::DEFB, 0x92);
    out_def_val_data.emplace_back(Keyword::DEFB, 0x50 | (slot & 0x07));

    return true;
}
