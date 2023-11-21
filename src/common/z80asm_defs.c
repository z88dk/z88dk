//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "z80asm_defs.h"
#include <limits.h>
#include <string.h>

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

