//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "utarray.h"
#include "utstring.h"
#include <stdlib.h>
#include <string.h>

//-----------------------------------------------------------------------------
// C-strings
//-----------------------------------------------------------------------------

// convert string to upper / lower case -modify in place,
// return address of string
extern char *cstr_toupper(char *str);
extern char *cstr_tolower(char *str);

// remove end newline and whitespace - modify in place, return address of string
extern char *cstr_chomp(char *str);

// remove begin and end whitespace - modify in place, return address of string
extern char *cstr_strip(char *str);

// convert C-escape sequences - modify in place, return final length
// to allow strings with '\0' characters
// accepts \b, \f, \n, \r, \t, \v, \xhh, \? \ooo
extern int cstr_compress_escapes(char *str);

// case insensitive compare
extern int cstr_case_cmp(const char *s1, const char *s2);
extern int cstr_case_ncmp(const char *s1, const char *s2, size_t n);

//-----------------------------------------------------------------------------
// str_t: alias to UT_string
//-----------------------------------------------------------------------------
typedef UT_string str_t;

#define str_data(x)		utstring_body(x)
#define str_len(x)		utstring_len(x)
#define str_sync_len(x)	(str_len(x) = strlen(str_data(x)))

extern str_t *str_new();
extern str_t *str_new_copy(const char *src);
extern void str_free(str_t *str);

extern void str_clear(str_t *str);

extern void str_reserve(str_t *str, size_t amt);

extern void str_set(str_t *str, const char *src);
extern void str_set_f(str_t *str, const char *fmt, ...);
extern void str_set_n(str_t *str, const char *data, size_t len);
extern void str_set_str(str_t *str, str_t *src);

extern void str_append(str_t *str, const char *src);
extern void str_append_f(str_t *str, const char *fmt, ...);
extern void str_append_n(str_t *str, const char *data, size_t len);
extern void str_append_str(str_t *str, str_t *src);

// apply a cstr function to the body of an str
extern void str_apply(str_t *str, char *(*f)(char*));

#define str_toupper(s)			str_apply((s), cstr_toupper)
#define str_tolower(s)			str_apply((s), cstr_tolower)
#define str_chomp(s)			str_apply((s), cstr_chomp)
#define str_strip(s)			str_apply((s), cstr_strip)
#define str_compress_escapes(s)	str_apply((s), (char *(*)(char*))cstr_compress_escapes)

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

//-----------------------------------------------------------------------------
// string pool
//-----------------------------------------------------------------------------
extern const char *spool_add(const char *str);
