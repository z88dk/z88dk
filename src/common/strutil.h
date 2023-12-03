//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include "utarray.h"
#include "utstring.h"
#include <stdlib.h>
#include <string.h>

#if defined(_WIN32) || defined(WIN32)
#ifndef strcasecmp
#define strcasecmp(s1, s2)		stricmp((s1), (s2))
#endif
#ifndef strncasecmp
#define strncasecmp(s1, s2, n)	strnicmp((s1), (s2), (n))
#endif
#else
#include <strings.h>
#endif

//-----------------------------------------------------------------------------
// C-strings
//-----------------------------------------------------------------------------

// convert string to upper / lower case -modify in place,
// return address of string
char* strtoupper(char* str);
char* strtolower(char* str);

// remove end newline and whitespace - modify in place, return address of string
char* strchomp(char* str);

// remove begin and end whitespace - modify in place, return address of string
char* strstrip(char* str);

// convert C-escape sequences - modify in place, return final length
// to allow strings with '\0' characters
// accepts \b, \f, \n, \r, \t, \v, \xhh, \? \ooo
size_t str_compress_escapes(char* str);

//-----------------------------------------------------------------------------
// argv_t: alias to UT_array of strings
//-----------------------------------------------------------------------------
typedef UT_array argv_t;

#define argv_eltptr(x, i)	((char**)utarray_eltptr((x), (i)))		// returns NULL if out ot range
#define argv_front(x)		((char**)_utarray_eltptr((x), 0))
#define argv_back(x)		((char**)_utarray_eltptr((x), utarray_len(x)))
#define argv_len(x)			utarray_len(x)

extern argv_t *argv_new();
extern void argv_free(argv_t *argv);
extern void argv_clear(argv_t *argv);

extern void argv_push(argv_t *argv, const char *str);
extern void argv_pop(argv_t *argv);
extern void argv_shift(argv_t *argv);
extern void argv_unshift(argv_t *argv, const char *str);
extern void argv_insert(argv_t *argv, size_t idx, const char *str);
extern void argv_erase(argv_t *argv, size_t pos, size_t len);

extern void argv_sort(argv_t *argv);

// get element by index, NULL if outside range
extern char *argv_get(argv_t *argv, size_t idx);

// set element at idx
// grows array if needed to make index valid, fills empty values with NULL
extern void argv_set(argv_t *argv, size_t idx, const char *str);

#ifdef __cplusplus
}
#endif
