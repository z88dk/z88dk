//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2022
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------

#pragma once

#include "utstring.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

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

// C-strings

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


// layer on top of UT_string
UT_string* utstr_new(void);
UT_string* utstr_new_init(const char* src);
bool utstr_fgets(UT_string* str, FILE* fp);
void utstr_reserve(UT_string* str, size_t amt);		// reszerve amt+1 after current len
void utstr_set(UT_string* dst, const char* src);
void utstr_set_n(UT_string* dst, const char* src, size_t n);
void utstr_set_fmt(UT_string* str, const char* fmt, ...);
void utstr_set_str(UT_string* str, UT_string* src);

#define utstr_body(s)				utstring_body(s)
#define utstr_len(s)				utstring_len(s)
#define utstr_sync_len(s)			(utstr_len(s) = strlen(utstr_body(s)))
#define utstr_clear(s)				utstring_clear(s)
#define utstr_append(s, text)		utstring_printf((s), "%s", (text))
#define utstr_append_n(s, text, n)	utstring_bincpy((s), (text), (n))
#define utstr_append_fmt(s, fmt,...)utstring_printf((s), (fmt), __VA_ARGS__)
#define utstr_append_str(s, src)	utstring_concat((s), (src))
#define utstr_free(s)				utstring_free(s)

void utstr_toupper(UT_string* str);
void utstr_tolower(UT_string* str);
void utstr_chomp(UT_string* str);
void utstr_strip(UT_string* str);
void utstr_compress_escapes(UT_string* str);
