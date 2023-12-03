//-----------------------------------------------------------------------------
// string table - map strings to integers
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "types.h"
#include <stdbool.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

// string table opaque interface
#ifndef STRTABLE_SOURCE
typedef void strtable_t;
#endif

extern void* strtable_new(void);
extern void strtable_free_(void* st);
#define strtable_free(st)   do { strtable_free_(st); (st) = NULL; } while (0)

extern void strtable_clear(void* st);
extern uint_t strtable_add_string(void* st, const char* str);   // return ID of existing string, or adds new
extern bool strtable_find(void* st, const char* str);           // check if string exists
extern const char* strtable_lookup(void* st, uint_t id);        // return string of given ID
extern uint_t strtable_size(void* st);                          // number of strings in table
extern void strtable_fwrite(void* st, FILE* fp);                // write to stream
extern void* strtable_fread(FILE* fp);                          // read from stream
extern void* strtable_parse(const byte_t* mem);                 // read from memory area

#ifdef __cplusplus
}
#endif
