//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "diag.h"
#include "lexer_keywords.h"
#include "string_utils.h"
#include <algorithm>
#include <cassert>
#include <sstream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <utility>
#include <vector>

CPU cpu_lookup(std::string_view name) {
    static const std::unordered_map<std::string, CPU> lu_table = {
#define X(code, id, name, defines)   { name, CPU::id },
#include "cpu.def"
    };

    std::string name_s(name);
    auto it = lu_table.find(to_lower(name_s));
    if (it == lu_table.end()) {
        return CPU::none;
    }
    else {
        return it->second;
    }
}

std::string cpu_name(CPU cpu_id) {
    // CPU ids may not be sequencial
    static const std::unordered_map<CPU, std::string> lu_table = {
#define X(code, id, name, defines)   { CPU::id, name },
#include "cpu.def"
    };

    auto it = lu_table.find(cpu_id);
    if (it == lu_table.end()) {
        assert(0);
        return "unknown";
    }
    else {
        return it->second;
    }
}

std::vector<std::string> cpu_names() {
    static std::vector<std::string> names = {
#define X(code, id, name, defines)   name,
#include "cpu.def"
    };
    std::sort(names.begin(),
              names.end());  // could be compile-time in C++20 with consteval and std::array
    return names;
}

static const
std::unordered_map<CPU, std::vector<std::string>>& cpu_defines_table() {
    static const std::unordered_map<CPU, std::vector<std::string>> table = []() {
        std::unordered_map<CPU, std::vector<std::string>> t;
        struct Entry {
            CPU id;
            const char* defines;
        };
        static const Entry entries[] = {
#define X(code, id, name, defines)   { CPU::id, defines },
#include "cpu.def"
        };
        for (const auto& e : entries) {
            std::vector<std::string> words;
            std::istringstream ss(e.defines);
            std::string word;
            while (ss >> word) {
                words.push_back(std::move(word));
            }
            t[e.id] = std::move(words);
        }
        return t;
    }
    ();
    return table;
}

std::vector<std::string> cpu_all_defines() {
    static const std::vector<std::string> all = []() {
        std::vector<std::string> result;
        for (const auto& [id, words] : cpu_defines_table()) {
            result.insert(result.end(), words.begin(), words.end());
        }
        std::sort(result.begin(), result.end());
        result.erase(std::unique(result.begin(), result.end()), result.end());
        return result;
    }
    ();
    return all;
}

std::vector<std::string> cpu_defines(CPU cpu_id) {
    const auto& table = cpu_defines_table();
    auto it = table.find(cpu_id);
    if (it == table.end())
        return {};
    return it->second;
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
        assert(0);
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

void swap_ix_iy(std::string& inout_text, Keyword& inout_kw) {
    if (keyword_is_x_register(inout_kw)) {
        swap_x_y(inout_text);
        inout_kw = keyword_lookup(inout_text);
    }
}

bool compute_cu_wait_value(int& out_value, CPU cpu_id, int ver, int hor,
                           const SourceLoc& kw_loc,
                           const SourceLoc& ver_loc,
                           const SourceLoc& hor_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, "CU_WAIT is only supported on the z80n");
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

    out_value = 0x8000 + (hor << 9) + ver;
    return true;
}

bool compute_cu_move_value(int& out_value, CPU cpu_id, int reg, int val,
                           const SourceLoc& kw_loc,
                           const SourceLoc& reg_loc,
                           const SourceLoc& val_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, "CU_MOVE is only supported on the z80n");
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

    out_value = ((reg & 0x7f) << 8) | (val & 0xff);
    return true;
}

bool compute_cu_stop_value(int& out_value, CPU cpu_id,
                           const SourceLoc& kw_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, "CU_STOP is only supported on the z80n");
        return false;
    }

    out_value = 0xFFFF;
    return true;
}

bool compute_cu_nop_value(int& out_value, CPU cpu_id, const SourceLoc& kw_loc) {
    if (cpu_id != CPU::z80n && cpu_id != CPU::z80n_strict) {
        g_diag.error(kw_loc, "CU_NOP is only supported on the z80n");
        return false;
    }

    out_value = 0x0000;
    return true;
}
