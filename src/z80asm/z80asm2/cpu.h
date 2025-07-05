//-----------------------------------------------------------------------------
// z80asm
// Recognized CPUs
// Copyright (C) Paulo Custodio, 2011-2025
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

enum class SwapIXIY {
    //@@BEGIN: SwapIXIY
    NO_SWAP = 0,
    SWAP = 1,
    SOFT_SWAP = 2,
    //@@END
};

struct CpuInfo {
    Cpu id;                 // cpu id
    string name;            // cpu name
    Cpu compat_parent_id;   // cpu id of compatible parent
    Cpu non_strict_id;      // cpu id of non-strict version
    bool is_strict;         // true if cpu is strict
    int level;              // level in dependency tree, 0 not compatible to any
    vector<string> defines; // defines for this CPU, used in preprocessor
};

class CpuTable {
public:
    CpuTable();

    const CpuInfo* get_info(Cpu id) const;                // nullptr if not found
    const CpuInfo* get_info(const string& name) const;    // nullptr if not found
    string cpu_names() const;
    string cpu_names(int lmargin, int rmargin) const;
    const vector<Cpu>& cpus_link_order() const { return m_cpus_link_order; }
    const vector<string>& cpu_defines(Cpu id) const;
    vector<string> all_defines() const;

private:
    static inline vector<CpuInfo> m_table = {
        //@@BEGIN: cpu_table
        { Cpu::Z80, "z80", Cpu::I8080, Cpu::Z80, false, -1, {"__CPU_Z80__","__CPU_ZILOG__"} }, // 1
        { Cpu::Z80_STRICT, "z80_strict", Cpu::I8080, Cpu::Z80, true, -1, {"__CPU_Z80_STRICT__","__CPU_ZILOG__"} }, // 2
        { Cpu::Z180, "z180", Cpu::I8080, Cpu::Z180, false, -1, {"__CPU_Z180__","__CPU_ZILOG__"} }, // 3
        { Cpu::EZ80_Z80, "ez80_z80", Cpu::UNDEF, Cpu::EZ80_Z80, false, -1, {"__CPU_EZ80_Z80__","__CPU_ZILOG__"} }, // 4
        { Cpu::EZ80, "ez80", Cpu::UNDEF, Cpu::EZ80, false, -1, {"__CPU_EZ80__","__CPU_ZILOG__"} }, // 5
        { Cpu::Z80N, "z80n", Cpu::Z80, Cpu::Z80N, false, -1, {"__CPU_Z80N__","__CPU_ZILOG__"} }, // 6
        { Cpu::R2KA, "r2ka", Cpu::UNDEF, Cpu::R2KA, false, -1, {"__CPU_R2KA__","__CPU_RABBIT__"} }, // 7
        { Cpu::R3K, "r3k", Cpu::R2KA, Cpu::R3K, false, -1, {"__CPU_R3K__","__CPU_RABBIT__"} }, // 8
        { Cpu::GBZ80, "gbz80", Cpu::UNDEF, Cpu::GBZ80, false, -1, {"__CPU_GBZ80__"} }, // 9
        { Cpu::I8080, "8080", Cpu::UNDEF, Cpu::I8080, false, -1, {"__CPU_8080__","__CPU_INTEL__"} }, // 10
        { Cpu::I8085, "8085", Cpu::I8080, Cpu::I8085, false, -1, {"__CPU_8085__","__CPU_INTEL__"} }, // 11
        { Cpu::R800, "r800", Cpu::I8080, Cpu::R800, false, -1, {"__CPU_R800__"} }, // 12
        { Cpu::R4K, "r4k", Cpu::UNDEF, Cpu::R4K, false, -1, {"__CPU_R4K__","__CPU_RABBIT__"} }, // 13
        { Cpu::R5K, "r5k", Cpu::R4K, Cpu::R5K, false, -1, {"__CPU_R5K__","__CPU_RABBIT__"} }, // 14
        { Cpu::KC160, "kc160", Cpu::UNDEF, Cpu::KC160, false, -1, {"__CPU_KC160__"} }, // 15
        { Cpu::KC160_Z80, "kc160_z80", Cpu::I8080, Cpu::KC160_Z80, false, -1, {"__CPU_KC160_Z80__"} }, // 16
        { Cpu::I8080_STRICT, "8080_strict", Cpu::UNDEF, Cpu::I8080, true, -1, {"__CPU_8080_STRICT__","__CPU_INTEL__"} }, // 17
        { Cpu::I8085_STRICT, "8085_strict", Cpu::I8080, Cpu::I8085, true, -1, {"__CPU_8085_STRICT__","__CPU_INTEL__"} }, // 18
        { Cpu::GBZ80_STRICT, "gbz80_strict", Cpu::UNDEF, Cpu::GBZ80, true, -1, {"__CPU_GBZ80_STRICT__"} }, // 19
        { Cpu::Z180_STRICT, "z180_strict", Cpu::I8080, Cpu::Z180, true, -1, {"__CPU_Z180_STRICT__","__CPU_ZILOG__"} }, // 20
        { Cpu::Z80N_STRICT, "z80n_strict", Cpu::Z80, Cpu::Z80N, true, -1, {"__CPU_Z80N_STRICT__","__CPU_ZILOG__"} }, // 21
        { Cpu::EZ80_Z80_STRICT, "ez80_z80_strict", Cpu::UNDEF, Cpu::EZ80_Z80, true, -1, {"__CPU_EZ80_Z80_STRICT__","__CPU_ZILOG__"} }, // 22
        { Cpu::EZ80_STRICT, "ez80_strict", Cpu::UNDEF, Cpu::EZ80, true, -1, {"__CPU_EZ80_STRICT__","__CPU_ZILOG__"} }, // 23
        { Cpu::R800_STRICT, "r800_strict", Cpu::I8080, Cpu::R800, true, -1, {"__CPU_R800_STRICT__"} }, // 24
        { Cpu::KC160_STRICT, "kc160_strict", Cpu::UNDEF, Cpu::KC160, true, -1, {"__CPU_KC160_STRICT__"} }, // 25
        { Cpu::KC160_Z80_STRICT, "kc160_z80_strict", Cpu::I8080, Cpu::KC160_Z80, true, -1, {"__CPU_KC160_Z80_STRICT__"} }, // 26
        { Cpu::R2KA_STRICT, "r2ka_strict", Cpu::UNDEF, Cpu::R2KA, true, -1, {"__CPU_R2KA_STRICT__","__CPU_RABBIT__"} }, // 27
        { Cpu::R3K_STRICT, "r3k_strict", Cpu::R2KA, Cpu::R3K, true, -1, {"__CPU_R3K_STRICT__","__CPU_RABBIT__"} }, // 28
        { Cpu::R4K_STRICT, "r4k_strict", Cpu::UNDEF, Cpu::R4K, true, -1, {"__CPU_R4K_STRICT__","__CPU_RABBIT__"} }, // 29
        { Cpu::R5K_STRICT, "r5k_strict", Cpu::R4K, Cpu::R5K, true, -1, {"__CPU_R5K_STRICT__","__CPU_RABBIT__"} }, // 30
        { Cpu::R6K, "r6k", Cpu::R5K, Cpu::R6K, false, -1, {"__CPU_R6K__","__CPU_RABBIT__"} }, // 31
        { Cpu::R6K_STRICT, "r6k_strict", Cpu::R5K, Cpu::R6K, true, -1, {"__CPU_R6K_STRICT__","__CPU_RABBIT__"} }, // 32
        //@@END
    };
    unordered_map<string, Cpu> m_by_name;
    vector<string> m_cpu_names;
    vector<Cpu> m_cpus_link_order;

    int index(Cpu id) const; // -1 if not found
};

bool cpu_compatible(Cpu code_cpu_id, Cpu lib_cpu_id);
extern CpuTable* g_cpu_table;

enum class Arch {
    //@@BEGIN: Arch
    UNDEF = -1,
    Z88 = 1,
    TI83 = 2,
    TI83PLUS = 3,
    ZX = 4,
    ZX81 = 5,
    ZXN = 6,
    //@@END
};

struct ArchInfo {
    Arch id;                // architecture id
    string name;            // architecture name
    Cpu cpu_id;             // CPU id for this architecture
    vector<string> defines; // defines for this architecture
};

class ArchTable {
public:
    ArchTable();

    const ArchInfo* get_info(Arch id) const;            // nullptr if not found
    const ArchInfo* get_info(const string& name) const; // nullptr if not found

    string arch_names() const;
    string arch_names(int lmargin, int rmargin) const;
    const vector<string>& arch_defines(Arch id) const;
    vector<string> all_defines() const;

private:
    static inline vector<ArchInfo> m_table = {
        //@@BEGIN: arch_table
        { Arch::Z88, "z88", Cpu::Z80, {"__ARCH_Z88__"} }, // 1
        { Arch::TI83, "ti83", Cpu::Z80, {"__ARCH_TI83__"} }, // 2
        { Arch::TI83PLUS, "ti83plus", Cpu::Z80, {"__ARCH_TI83PLUS__"} }, // 3
        { Arch::ZX, "zx", Cpu::Z80, {"__ARCH_ZX__"} }, // 4
        { Arch::ZX81, "zx81", Cpu::Z80, {"__ARCH_ZX81__"} }, // 5
        { Arch::ZXN, "zxn", Cpu::Z80N, {"__ARCH_ZXN__"} }, // 6
        //@@END
    };
    unordered_map<string, Arch> m_by_name;
    vector<string> m_arch_names;

    int index(Arch id) const; // -1 if not found
};

extern ArchTable* g_arch_table;

inline int Z80_RST(int addr) {
    return 0xC7 + ((addr) < 8 ? (addr) * 8 : (addr));
}

