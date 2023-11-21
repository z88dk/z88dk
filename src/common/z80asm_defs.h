//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifndef NUM_ELEMS
#define NUM_ELEMS(a)    (sizeof(a) / sizeof(a[0]))
#endif

// assertion that is not removed in a release compile
#ifndef xassert
#define xassert(f)      do { \
							if (!(f)) { \
								fprintf(stderr, "assertion failed in %s:%d\n", __FILE__, __LINE__); \
                                exit(EXIT_FAILURE); \
                            } \
						} while(0)
#endif

//-----------------------------------------------------------------------------
// Scope of symbol
// Initially defined as LOCAL
//-----------------------------------------------------------------------------

typedef enum {
    SCOPE_NONE,     // 0
    SCOPE_LOCAL,    // 1 "L"
    SCOPE_PUBLIC,   // 2 "G"            - defined and exported
    SCOPE_EXTERN,   // 3                - not defined and imported
    SCOPE_GLOBAL,   // 4 "G" if defined - PUBLIC if defined, EXTERN if not defined
} sym_scope_t;

// convert sym_scope_t to text, return NULL if not found
extern const char* sym_scope_str_short(sym_scope_t type);
extern const char* sym_scope_str_long(sym_scope_t type);

// convert object file old-style letter code to sym_scope_t
extern sym_scope_t sym_scope_ofile_code(int code);

//-----------------------------------------------------------------------------
// Type of symbol
// Expressions have the type of the greatest symbol used
//-----------------------------------------------------------------------------

typedef enum {
    TYPE_UNDEFINED, // 0     - symbol not defined
    TYPE_CONSTANT,	// 1 "C" - can be computed
    TYPE_ADDRESS,	// 2 "A" - depends on ASMPC, can be computed after address allocation
    TYPE_COMPUTED,	// 3 "=" - depends on the result of an expression
} sym_type_t;

// convert sym_type_t to text, return NULL if not found
extern const char* sym_type_str_long(sym_type_t type);
extern const char* sym_type_str_short(sym_type_t type);

// convert object file old-style letter code to sym_type_t
extern sym_type_t sym_type_ofile_code(int code);

//-----------------------------------------------------------------------------
// Expression range
//-----------------------------------------------------------------------------

typedef enum {
    RANGE_UNDEFINED,                // 0  
    RANGE_JR_OFFSET,                // 1  "J"
    RANGE_BYTE_UNSIGNED,            // 2  "U"
    RANGE_BYTE_SIGNED,              // 3  "S"
    RANGE_WORD,						// 4  "W"  // 16-bit value little-endian
    RANGE_WORD_BE,					// 5  "B"  // 16-bit value big-endian
    RANGE_DWORD,                    // 6  "L"  // 32-bit signed
    RANGE_BYTE_TO_WORD_UNSIGNED,    // 7  "u"  // unsigned byte extended to 16 bits
    RANGE_BYTE_TO_WORD_SIGNED,      // 8  "s"  // signed byte sign-extended to 16 bits
    RANGE_PTR24,					// 9  "P"  // 24-bit pointer
    RANGE_HIGH_OFFSET,				// 10 "H"  // byte offset to 0xFF00
    RANGE_ASSIGNMENT,               // 11 "="  // DEFC expression assigning a symbol
    RANGE_JRE_OFFSET,               // 12 "j"  // 16-bit relative offset for JRE
} range_t;

// size of each range in object file
extern int range_size(range_t type);

// convert sym_type_t to text, return NULL if not found
extern const char* range_str_short(range_t type);

// convert object file old-style letter code to sym_type_t
extern range_t range_ofile_code(int code);

#ifdef __cplusplus
}
#endif
