//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2023
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
