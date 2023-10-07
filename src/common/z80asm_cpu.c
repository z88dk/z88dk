//-----------------------------------------------------------------------------
// z80asm cpu's
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "z80asm_cpu.h"
#include "die.h"
#include "uthash.h"

typedef struct {
    const char* str;
    int id;
    UT_hash_handle hh;
} map_string_int_t;

// hash table to lookup CPUs
static map_string_int_t map_cpu_ids[] = {
#define X(id, value, name)      {name, id},
#include "z80asm_cpu.def"
    {NULL, 0}
};

static map_string_int_t* map_cpu_ids_hash = NULL;

static UT_string* cpus_list = NULL;

static int by_str(const map_string_int_t* a, const map_string_int_t* b) {
    return strcmp(a->str, b->str);
}

static void init() {
    static bool inited = false;
    if (!inited) {
        for (map_string_int_t* p = map_cpu_ids; p->str != NULL; p++) {
            const char* str = p->str;
            HASH_ADD_STR(map_cpu_ids_hash, str, p);
        }
        HASH_SORT(map_cpu_ids_hash, by_str);

        utstring_new(cpus_list);
        const char* sep = "";
        for (map_string_int_t* p = map_cpu_ids_hash; p != NULL; p = (map_string_int_t*)(p->hh.next)) {
            utstring_printf(cpus_list, "%s%s", sep, p->str);
            sep = ",";
        }
        inited = true;
    }
}

const char* cpu_name(int cpu_id) {
    switch (cpu_id) {
#define X(id, value, name)      case id: return name;
#include "z80asm_cpu.def"
    default:;
    }
    return NULL;
}

int cpu_id(const char* name) {
    init();

    map_string_int_t* found;
    HASH_FIND_STR(map_cpu_ids_hash, name, found);
    if (found)
        return found->id;
    else
        return -1;
}

const char* cpu_list() {
    init();

    return utstring_body(cpus_list);
}

const int* cpu_ids() {
    static int cpu_ids[] = {
#define X(id, value, name)      id,
#include "z80asm_cpu.def"
        -1
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
            case CPU_Z80_STRICT: case CPU_8080: return true;
            default: return false;
            }
        case CPU_Z80_STRICT:
            switch (lib_cpu_id) {
            case CPU_8080: return true;
            default: return false;
            }
        case CPU_Z80N:
            switch (lib_cpu_id) {
            case CPU_Z80: case CPU_Z80_STRICT: case CPU_8080: return true;
            default: return false;
            }
        case CPU_Z180:
            switch (lib_cpu_id) {
            case CPU_Z80_STRICT: case CPU_8080: return true;
            default: return false;
            }
        case CPU_EZ80:
            return false;
        case CPU_EZ80_Z80:
            return false;
        case CPU_R800:
            switch (lib_cpu_id) {
            case CPU_Z80_STRICT: case CPU_8080: return true;
            default: return false;
            }
        case CPU_R2KA:
            return false;
        case CPU_R3K:
            switch (lib_cpu_id) {
            case CPU_R2KA: return true;
            default: return false;
            }
        case CPU_R4K:
            return false;
        case CPU_R5K:
            switch (lib_cpu_id) {
            case CPU_R4K: return true;
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
		case CPU_KC160:
            return false;
		case CPU_KC160_Z80:
            switch (lib_cpu_id) {
            case CPU_Z80_STRICT: case CPU_8080: return true;
            default: return false;
            }
        default:
            xassert(0);
            return false;
        }
    }
}

// linking with no-swap accepts object files assembled with soft-swap
bool ixiy_compatible(swap_ixiy_t code_swap_ixiy, swap_ixiy_t lib_swap_ixiy) {
    if (code_swap_ixiy == IXIY_NO_SWAP && lib_swap_ixiy == IXIY_SOFT_SWAP)
        return true;
    else if (code_swap_ixiy == IXIY_SOFT_SWAP && lib_swap_ixiy == IXIY_NO_SWAP)
        return true;
    else if (code_swap_ixiy != lib_swap_ixiy)
        return false;
    else
        return true;
}
