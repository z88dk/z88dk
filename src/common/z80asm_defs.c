//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "types.h"
#include "utarray.h"
#include "uthash.h"
#include "utstring.h"
#include "xassert.h"
#include "z80asm_defs.h"
#include <limits.h>
#include <string.h>

typedef struct cpu_lookup_s {
    const char* name;           // cpu name
    cpu_t id;                   // cpu id
    cpu_t compat_parent;        // cpu id of compatible parent
    cpu_t non_strict;           // cpu id of non-strict version
    bool is_strict;             // true if cpu is strict
    int level;                  // level in dependency tree, 0 not compatible to any
    UT_hash_handle hh;          // hash table
} cpu_lookup_t;

typedef struct {
    int code;                   // code read from object file
    const char* str_short;      // string output by z80nm
    const char* str_long;       // string output in map file
} sym_lookup_t;

typedef struct {
    int code;                   // code read from object file
    const char* str_short;      // string output by z80nm
    int size;                   // size of expression in object file
} range_lookup_t;

//-----------------------------------------------------------------------------
// CPUs
//-----------------------------------------------------------------------------

static cpu_lookup_t cpu_lut[] = {
//    name          		id                  	parent      non-strict      is-strict
    { "z80",        		CPU_Z80,            	CPU_8080,   CPU_Z80,        false,  },  // 1
    { "z80_strict", 		CPU_Z80_STRICT,     	CPU_8080,   CPU_Z80,        true,   },  // 2
    { "z180",       		CPU_Z180,           	CPU_8080,   CPU_Z180,       false,  },  // 3
    { "ez80_z80",   		CPU_EZ80_Z80,       	CPU_UNDEF,  CPU_EZ80_Z80,   false,  },  // 4
    { "ez80",       		CPU_EZ80,           	CPU_UNDEF,  CPU_EZ80,       false,  },  // 5
    { "z80n",       		CPU_Z80N,           	CPU_Z80,    CPU_Z80N,       false,  },  // 6
    { "r2ka",       		CPU_R2KA,           	CPU_UNDEF,  CPU_R2KA,       false,  },  // 7
    { "r3k",        		CPU_R3K,            	CPU_R2KA,   CPU_R3K,        false,  },  // 8
    { "gbz80",      		CPU_GBZ80,          	CPU_UNDEF,  CPU_GBZ80,      false,  },  // 9
    { "8080",       		CPU_8080,           	CPU_UNDEF,  CPU_8080,       false,  },  // 10
    { "8085",       		CPU_8085,           	CPU_8080,   CPU_8085,       false,  },  // 11
    { "r800",       		CPU_R800,           	CPU_8080,   CPU_R800,       false,  },  // 12
    { "r4k",        		CPU_R4K,            	CPU_UNDEF,  CPU_R4K,        false,  },  // 13
    { "r5k",        		CPU_R5K,            	CPU_R4K,    CPU_R5K,        false,  },  // 14
    { "kc160",      		CPU_KC160,          	CPU_UNDEF,  CPU_KC160,      false,  },  // 15
    { "kc160_z80",  		CPU_KC160_Z80,      	CPU_8080,   CPU_KC160_Z80,  false,  },  // 16
    { "8080_strict",		CPU_8080_STRICT,    	CPU_UNDEF,  CPU_8080,       true,   },  // 17
    { "8085_strict",		CPU_8085_STRICT,    	CPU_8080,   CPU_8085,       true,   },  // 18
    { "gbz80_strict",		CPU_GBZ80_STRICT,		CPU_UNDEF,  CPU_GBZ80,      true,   },  // 19
    { "z180_strict",		CPU_Z180_STRICT,  		CPU_8080,   CPU_Z180,       true,   },  // 20
    { "z80n_strict",		CPU_Z80N_STRICT,  		CPU_Z80,    CPU_Z80N,       true,   },  // 21
    { "ez80_z80_strict",	CPU_EZ80_Z80_STRICT,	CPU_UNDEF,  CPU_EZ80_Z80,   true,   },  // 22
    { "ez80_strict",    	CPU_EZ80_STRICT,    	CPU_UNDEF,	CPU_EZ80,       true,   },  // 23
    { "r800_strict",   		CPU_R800_STRICT,		CPU_8080,   CPU_R800,       true,   },  // 24
    { "kc160_strict",   	CPU_KC160_STRICT,		CPU_UNDEF,  CPU_KC160,      true,   },  // 25
    { "kc160_z80_strict",	CPU_KC160_Z80_STRICT,	CPU_8080,   CPU_KC160_Z80,  true,   },  // 26
    { "r2ka_strict",       	CPU_R2KA_STRICT,        CPU_UNDEF,  CPU_R2KA,       true,   },  // 27
    { "r3k_strict",        	CPU_R3K_STRICT,         CPU_R2KA,   CPU_R3K,        true,   },  // 28
    { "r4k_strict",        	CPU_R4K_STRICT,         CPU_UNDEF,  CPU_R4K,        true,   },  // 29
    { "r5k_strict",			CPU_R5K_STRICT,			CPU_R4K,    CPU_R5K,        true,   },  // 30
    { "r6k",        		CPU_R6K,            	CPU_R5K,    CPU_R6K,        false,  },  // 31
    { "r6k_strict",    		CPU_R6K_STRICT,        	CPU_R5K,    CPU_R6K,        true,   },  // 32
};

static cpu_lookup_t* cpu_lu_hash = NULL;        // lookup from cpu name
static UT_string* cpu_names_string = NULL;      // ordered list of cpu names sep. by comma
static UT_array* cpu_ids_array;                 // ordered list of cpu-ids in the link order in libs
static int max_cpu_compat_level = 0;            // max compatibility level

static int by_str(const cpu_lookup_t* a, const cpu_lookup_t* b) {
    return strcmp(a->name, b->name);
}

static cpu_lookup_t* cpu_id_to_lookup(cpu_t id) {
    int i = (int)id - 1;
    if (i >= 0 && i < NUM_ELEMS(cpu_lut))
        return &cpu_lut[i];
    else
        return NULL;
}

static void init_cpus() {
    static bool inited = false;
    if (!inited) {
        // init hash table
        for (size_t i = 0; i < NUM_ELEMS(cpu_lut); i++) {
            const char* name = cpu_lut[i].name;
            HASH_ADD_STR(cpu_lu_hash, name, &cpu_lut[i]);
        }
        HASH_SORT(cpu_lu_hash, by_str);

        // init string of cpu names
        utstring_new(cpu_names_string);
        const char* sep = "";
        for (cpu_lookup_t* p = cpu_lu_hash; p != NULL; p = (cpu_lookup_t*)(p->hh.next)) {
            utstring_printf(cpu_names_string, "%s%s", sep, p->name);
            sep = ",";
        }

        // init dependency level
        for (size_t i = 0; i < NUM_ELEMS(cpu_lut); i++) {
            if (cpu_lut[i].compat_parent == CPU_UNDEF || cpu_lut[i].is_strict)
                cpu_lut[i].level = 0;            // no comaptibility
            else
                cpu_lut[i].level = -1;           // still to check
        }

        bool done = false;
        do {
            done = true;
            for (size_t i = 0; i < NUM_ELEMS(cpu_lut); i++) {
                if (cpu_lut[i].level < 0) {      // not yet traversed
                    cpu_t parent = cpu_lut[i].compat_parent;
                    cpu_lookup_t* parent_p = cpu_id_to_lookup(parent);
                    if (parent_p->level >= 0) {
                        cpu_lut[i].level = parent_p->level + 1;
                        if (cpu_lut[i].level > max_cpu_compat_level)
                            max_cpu_compat_level = cpu_lut[i].level;
                    }

                    done = false;
                }
            }
        } while (!done);

        // init orderd list of cpu-ids in library link order
        utarray_new(cpu_ids_array, &ut_int_icd);
        for (int level = max_cpu_compat_level; level >= 0; level--) {
            for (size_t i = 0; i < NUM_ELEMS(cpu_lut); i++) {
                if (cpu_lut[i].level == level)
                    utarray_push_back(cpu_ids_array, &cpu_lut[i].id);
            }
        }
        int id = CPU_UNDEF;
        utarray_push_back(cpu_ids_array, &id);

        // all dobe
        inited = true;
    }
}

// convert cpu_t to string, NULL if not found
const char* cpu_name(cpu_t id) {
    init_cpus();
    cpu_lookup_t* found = cpu_id_to_lookup(id);
    if (found)
        return found->name;
    else
        return NULL;
}

// lookup cpu name, return cpu_t, CPU_UNDEF if not found
cpu_t cpu_id(const char* name) {
    init_cpus();
    cpu_lookup_t* found;
    HASH_FIND_STR(cpu_lu_hash, name, found);
    if (found)
        return found->id;
    else
        return CPU_UNDEF;
}

// check if CPU is strict
bool cpu_is_strict(cpu_t id) {
    init_cpus();
    cpu_lookup_t* found = cpu_id_to_lookup(id);
    if (found)
        return found->is_strict;
    else
        return false;
}

// return non-strict version of cpu
cpu_t cpu_unstrictify(cpu_t id) {
    init_cpus();
    cpu_lookup_t* found = cpu_id_to_lookup(id);
    if (found)
        return found->non_strict;
    else
        return id;
}

// static comma-separated list of cpu names
const char* cpu_list() {
    init_cpus();
    return utstring_body(cpu_names_string);
}

// return list terminated by CPU_UNDEF of all CPUs in the order more specific to more generic
const int* cpu_ids() {
    init_cpus();
    return (int*)utarray_eltptr(cpu_ids_array, 0);
}

// check if a code cpu is compatible with a library cpu
bool cpu_compatible(cpu_t code_cpu_id, cpu_t lib_cpu_id) {
    init_cpus();
    code_cpu_id = cpu_unstrictify(code_cpu_id);
    lib_cpu_id = cpu_unstrictify(lib_cpu_id);

    cpu_t id = code_cpu_id;
    while (id != CPU_UNDEF) {
        if (id == lib_cpu_id)
            return true;
        else {
            cpu_lookup_t* found = cpu_id_to_lookup(id);
            xassert(found);
            id = found->compat_parent;
        }
    }
    return false;
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

//-----------------------------------------------------------------------------
// Scope of symbol
//-----------------------------------------------------------------------------

static sym_lookup_t sym_scope_lu[] = {
    { INT_MAX,  NULL,   "none" },       // SCOPE_NONE
    { 'L',      "L",    "local" },      // SCOPE_LOCAL
    { 'G',      "G",    "public" },     // SCOPE_PUBLIC
    { INT_MAX,  NULL,   "extern" },     // SCOPE_EXTERN
    { INT_MAX,  NULL,   "global" },     // SCOPE_GLOBAL
};

// convert sym_scope_t to text, return NULL if not found
const char* sym_scope_str_short(sym_scope_t type) {
    if (type < 0 || type >= NUM_ELEMS(sym_scope_lu))
        return NULL;
    else
        return sym_scope_lu[type].str_short;
}

const char* sym_scope_str_long(sym_scope_t type) {
    if (type < 0 || type >= NUM_ELEMS(sym_scope_lu))
        return NULL;
    else
        return sym_scope_lu[type].str_long;
}

// convert object file old-style letter code to sym_scope_t
sym_scope_t sym_scope_ofile_code(int code) {
    for (int i = 0; i < NUM_ELEMS(sym_scope_lu); i++) {
        if (sym_scope_lu[i].code == code)
            return (sym_scope_t)i;
    }
    return SCOPE_NONE;
}

//-----------------------------------------------------------------------------
// Type of symbol
//-----------------------------------------------------------------------------

static sym_lookup_t sym_type_lu[] = {
    { INT_MAX,  "?",    "undef" },      // TYPE_UNDEFINED
    { 'C',      "C",    "const" },      // TYPE_CONSTANT
    { 'A',      "A",    "addr" },       // TYPE_ADDRESS
    { '=',      "=",    "comput" },     // TYPE_COMPUTED
};

// convert sym_type_t to text, return NULL if not found
const char* sym_type_str_short(sym_type_t type) {
    if (type < 0 || type >= NUM_ELEMS(sym_type_lu))
        return NULL;
    else
        return sym_type_lu[type].str_short;
}

const char* sym_type_str_long(sym_type_t type) {
    if (type < 0 || type >= NUM_ELEMS(sym_type_lu))
        return NULL;
    else
        return sym_type_lu[type].str_long;
}

// convert object file old-style letter code to sym_type_t
sym_type_t sym_type_ofile_code(int code) {
    for (int i = 0; i < NUM_ELEMS(sym_type_lu); i++) {
        if (sym_type_lu[i].code == code)
            return (sym_type_t)i;
    }
    return TYPE_UNDEFINED;
}

//-----------------------------------------------------------------------------
// Expression range
//-----------------------------------------------------------------------------

static range_lookup_t range_lu[] = {
    { INT_MAX,  "?",    -1 },     // RANGE_UNDEFINED
    { 'J',      "J",    1 },      // RANGE_JR_OFFSET
    { 'U',      "U",    1 },      // RANGE_BYTE_UNSIGNED
    { 'S',      "S",    1 },      // RANGE_BYTE_SIGNED
    { 'C',      "W",    2 },      // RANGE_WORD
    { 'B',      "B",    2 },      // RANGE_WORD_BE
    { 'L',      "L",    4 },      // RANGE_DWORD
    { 'u',      "u",    2 },      // RANGE_BYTE_TO_WORD_UNSIGNED
    { 's',      "s",    2 },      // RANGE_BYTE_TO_WORD_SIGNED
    { 'P',      "P",    3 },      // RANGE_PTR24
    { 'H',      "H",    1 },      // RANGE_HIGH_OFFSET
    { '=',      "=",    2 },      // RANGE_ASSIGNMENT
    { 'j',      "j",    2 },      // RANGE_JRE_OFFSET
    { 'v',      "v",    3 },      // RANGE_BYTE_TO_PTR_UNSIGNED
    { 't',      "t",    3 },      // RANGE_BYTE_TO_PTR_SIGNED
};

// size of each range in object file
int range_size(range_t type) {
    if (type < 0 || type >= NUM_ELEMS(range_lu)) {
        xassert(0);
        return -1;
    }
    else {
        return range_lu[type].size;
    }
}

// convert sym_type_t to text, return NULL if not found
const char* range_str_short(range_t type) {
    if (type < 0 || type >= NUM_ELEMS(range_lu))
        return NULL;
    else
        return range_lu[type].str_short;
}

// convert object file old-style letter code to sym_type_t
range_t range_ofile_code(int code) {
    for (int i = 0; i < NUM_ELEMS(range_lu); i++) {
        if (range_lu[i].code == code)
            return (sym_type_t)i;
    }
    return RANGE_UNDEFINED;
}

