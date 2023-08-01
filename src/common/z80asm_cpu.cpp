//-----------------------------------------------------------------------------
// z80asm cpu's
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "z80asm_cpu.h"
#include <algorithm>
#include <cassert>
#include <iostream>
#include <map>
#include <string>
#include <vector>
using namespace std;

// Assert for internal errors, similar to assert but not removed in release builds
#define Assert(f)    do { \
                        if (!(f)) { \
                            cerr << "z88dk-z80asm panic at " << __FILE__ << ":" << __LINE__ << endl; \
                            exit(EXIT_FAILURE); \
                        } \
                    } while(0)


const char* cpu_name(int cpu_id) {
    switch (cpu_id) {
#define X(id, value, name)      case id: return name;
#include "z80asm_cpu.def"
    default: Assert(0);
    }
    return "";  // not reached
}

int cpu_id(const char* name) {
    static std::map<string, int> cpu_map = {
#define X(id, value, name)      {name, id},
#include "z80asm_cpu.def"
    };

    auto it = cpu_map.find(name);
    if (it != cpu_map.end())
        return it->second;
    else
        return -1;
}

const char* cpu_list() {
    static vector<string> cpus_list = {
#define X(id, value, name)      name,
#include "z80asm_cpu.def"
    };
    static string cpus;

    if (cpus.empty()) {
        std::sort(cpus_list.begin(), cpus_list.end());
        for (auto& i : cpus_list)
            cpus += i + ",";

        if (!cpus.empty())
            cpus.pop_back();    // remove last comma
    }

    return cpus.c_str();        // must be static
}

const int* cpu_ids() {
    static int cpu_ids[] = {
#define X(id, value, name)      id,
#include "z80asm_cpu.def"
        - 1
    };

    return &cpu_ids[0];
}

bool cpu_compatible(int code_cpu_id, int lib_cpu_id) {
    if (code_cpu_id == lib_cpu_id)
        return true;
    else {
        switch (code_cpu_id) {
        case CPU_Z80:
            switch (lib_cpu_id) {
            case CPU_8080: return true;
            default: return false;
            }
        case CPU_Z80N:
            switch (lib_cpu_id) {
            case CPU_Z80: case CPU_8080: return true;
            default: return false;
            }
        case CPU_Z180:
            switch (lib_cpu_id) {
            case CPU_8080: return true;
            default: return false;
            }
        case CPU_EZ80:
            return false;
        case CPU_EZ80_Z80:
            switch (lib_cpu_id) {
            case CPU_Z180: case CPU_8080: return true;
            default: return false;
            }
        case CPU_R2KA:
            return false;
        case CPU_R3K:
            switch (lib_cpu_id) {
            case CPU_R2KA: return true;
            default: return false;
            }
        case CPU_8080:
            return false;
        case CPU_8085:
            switch (lib_cpu_id) {
            case CPU_8080: return true;
            default: return false;
            }
        case CPU_GBZ80:
            return false;
        default:
            Assert(0);
        }
    }
}
