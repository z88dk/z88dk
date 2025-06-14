//-----------------------------------------------------------------------------
// z80asm
// Recognized CPUs
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

enum class Cpu {
    //@@BEGIN: cpu_id
    UNDEF = -1,
    Z80 = 1,
    Z80_STRICT = 2,
    Z180 = 3,
    EZ80_Z80 = 4,
    EZ80 = 5,
    Z80N = 6,
    R2KA = 7,
    R3K = 8,
    GBZ80 = 9,
    I8080 = 10,
    I8085 = 11,
    R800 = 12,
    R4K = 13,
    R5K = 14,
    KC160 = 15,
    KC160_Z80 = 16,
    I8080_STRICT = 17,
    I8085_STRICT = 18,
    GBZ80_STRICT = 19,
    Z180_STRICT = 20,
    Z80N_STRICT = 21,
    EZ80_Z80_STRICT = 22,
    EZ80_STRICT = 23,
    R800_STRICT = 24,
    KC160_STRICT = 25,
    KC160_Z80_STRICT = 26,
    R2KA_STRICT = 27,
    R3K_STRICT = 28,
    R4K_STRICT = 29,
    R5K_STRICT = 30,
    R6K = 31,
    R6K_STRICT = 32,
    //@@END
};

struct CpuInfo {
    string name;            // cpu name
    Cpu id;                 // cpu id
    Cpu compat_parent_id;   // cpu id of compatible parent
    Cpu non_strict_id;      // cpu id of non-strict version
    bool is_strict;         // true if cpu is strict
    int level;              // level in dependency tree, 0 not compatible to any
};

class CpuTable {
public:
    CpuTable();

    const CpuInfo* get_info(Cpu id);                // nullptr if not found
    const CpuInfo* get_info(const string& name);    // nullptr if not found
    string cpu_names() const;
    string cpu_names(int lmargin, int rmargin);
    const vector<Cpu>& cpus_link_order() const { return m_cpus_link_order; }

private:
    vector<CpuInfo> m_table = {
        //@@BEGIN: cpu_table
        { "z80", Cpu::Z80, Cpu::I8080, Cpu::Z80, false, -1 }, // 1
        { "z80_strict", Cpu::Z80_STRICT, Cpu::I8080, Cpu::Z80, true, -1 }, // 2
        { "z180", Cpu::Z180, Cpu::I8080, Cpu::Z180, false, -1 }, // 3
        { "ez80_z80", Cpu::EZ80_Z80, Cpu::UNDEF, Cpu::EZ80_Z80, false, -1 }, // 4
        { "ez80", Cpu::EZ80, Cpu::UNDEF, Cpu::EZ80, false, -1 }, // 5
        { "z80n", Cpu::Z80N, Cpu::Z80, Cpu::Z80N, false, -1 }, // 6
        { "r2ka", Cpu::R2KA, Cpu::UNDEF, Cpu::R2KA, false, -1 }, // 7
        { "r3k", Cpu::R3K, Cpu::R2KA, Cpu::R3K, false, -1 }, // 8
        { "gbz80", Cpu::GBZ80, Cpu::UNDEF, Cpu::GBZ80, false, -1 }, // 9
        { "8080", Cpu::I8080, Cpu::UNDEF, Cpu::I8080, false, -1 }, // 10
        { "8085", Cpu::I8085, Cpu::I8080, Cpu::I8085, false, -1 }, // 11
        { "r800", Cpu::R800, Cpu::I8080, Cpu::R800, false, -1 }, // 12
        { "r4k", Cpu::R4K, Cpu::UNDEF, Cpu::R4K, false, -1 }, // 13
        { "r5k", Cpu::R5K, Cpu::R4K, Cpu::R5K, false, -1 }, // 14
        { "kc160", Cpu::KC160, Cpu::UNDEF, Cpu::KC160, false, -1 }, // 15
        { "kc160_z80", Cpu::KC160_Z80, Cpu::I8080, Cpu::KC160_Z80, false, -1 }, // 16
        { "8080_strict", Cpu::I8080_STRICT, Cpu::UNDEF, Cpu::I8080, true, -1 }, // 17
        { "8085_strict", Cpu::I8085_STRICT, Cpu::I8080, Cpu::I8085, true, -1 }, // 18
        { "gbz80_strict", Cpu::GBZ80_STRICT, Cpu::UNDEF, Cpu::GBZ80, true, -1 }, // 19
        { "z180_strict", Cpu::Z180_STRICT, Cpu::I8080, Cpu::Z180, true, -1 }, // 20
        { "z80n_strict", Cpu::Z80N_STRICT, Cpu::Z80, Cpu::Z80N, true, -1 }, // 21
        { "ez80_z80_strict", Cpu::EZ80_Z80_STRICT, Cpu::UNDEF, Cpu::EZ80_Z80, true, -1 }, // 22
        { "ez80_strict", Cpu::EZ80_STRICT, Cpu::UNDEF, Cpu::EZ80, true, -1 }, // 23
        { "r800_strict", Cpu::R800_STRICT, Cpu::I8080, Cpu::R800, true, -1 }, // 24
        { "kc160_strict", Cpu::KC160_STRICT, Cpu::UNDEF, Cpu::KC160, true, -1 }, // 25
        { "kc160_z80_strict", Cpu::KC160_Z80_STRICT, Cpu::I8080, Cpu::KC160_Z80, true, -1 }, // 26
        { "r2ka_strict", Cpu::R2KA_STRICT, Cpu::UNDEF, Cpu::R2KA, true, -1 }, // 27
        { "r3k_strict", Cpu::R3K_STRICT, Cpu::R2KA, Cpu::R3K, true, -1 }, // 28
        { "r4k_strict", Cpu::R4K_STRICT, Cpu::UNDEF, Cpu::R4K, true, -1 }, // 29
        { "r5k_strict", Cpu::R5K_STRICT, Cpu::R4K, Cpu::R5K, true, -1 }, // 30
        { "r6k", Cpu::R6K, Cpu::R5K, Cpu::R6K, false, -1 }, // 31
        { "r6k_strict", Cpu::R6K_STRICT, Cpu::R5K, Cpu::R6K, true, -1 }, // 32
        //@@END
    };
    unordered_map<string, Cpu> m_by_name;
    vector<string> m_cpu_names;
    vector<Cpu> m_cpus_link_order;

    int index(Cpu id); // -1 if not found
};

extern CpuTable* g_cpu_table;
