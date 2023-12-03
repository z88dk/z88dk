//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "die.h"
#include "strutil.h"
#include "uthash.h"
#include "utstring.h"
#include "xassert.h"
#include "xmalloc.h"
#include <ctype.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdlib.h>

//-----------------------------------------------------------------------------
// C-strings
//-----------------------------------------------------------------------------

char* strtoupper(char* str) {
    for (char* p = str; *p; p++) *p = toupper(*p);
    return str;
}

char* strtolower(char* str) {
    for (char* p = str; *p; p++) *p = tolower(*p);
    return str;
}

char* strchomp(char* str) {
    for (char* p = str + strlen(str) - 1; p >= str && isspace(*p); p--) *p = '\0';
    return str;
}

char* strstrip(char* str) {
    char* p;
    for (p = str; *p != '\0' && isspace(*p); p++) {}// skip begining spaces
    memmove(str, p, strlen(p) + 1);					// move also '\0'
    return strchomp(str);							// remove ending spaces	
}

static int char_digit(char c) {
    if (isdigit(c)) return c - '0';
    if (isxdigit(c)) return 10 + toupper(c) - 'A';
    return -1;
}

/* convert C-escape sequences - modify in place, return final length
to allow strings with '\0' characters
Accepts \a, \b, \e, \f, \n, \r, \t, \v, \xhh, \{any} \ooo
code borrowed from GLib */
size_t str_compress_escapes(char* str) {
    char* p = NULL, * q = NULL, * num = NULL;
    int base = 0, max_digits, digit;

    for (p = q = str; *p; p++)
    {
        if (*p == '\\')
        {
            p++;
            base = 0;							/* decision octal/hex */
            switch (*p)
            {
            case '\0':	p--; break;				/* trailing backslash - ignore */
            case 'a':	*q++ = '\a'; break;
            case 'b':	*q++ = '\b'; break;
            case 'e':	*q++ = '\x1B'; break;
            case 'f':	*q++ = '\f'; break;
            case 'n':	*q++ = '\n'; break;
            case 'r':	*q++ = '\r'; break;
            case 't':	*q++ = '\t'; break;
            case 'v':	*q++ = '\v'; break;
            case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7':
                num = p;				/* start of number */
                base = 8;
                max_digits = 3;
                /* fall through */
            case 'x':
                if (base == 0)		/* not octal */
                {
                    num = ++p;
                    base = 16;
                    max_digits = 2;
                }
                /* convert octal or hex number */
                *q = 0;
                while (p < num + max_digits &&
                    (digit = char_digit(*p)) >= 0 &&
                    digit < base)
                {
                    *q = *q * base + digit;
                    p++;
                }
                p--;
                q++;
                break;
            default:	*q++ = *p;		/* any other char */
            }
        }
        else
        {
            *q++ = *p;
        }
    }
    *q = '\0';

    return q - str;
}

//-----------------------------------------------------------------------------
// string array
//-----------------------------------------------------------------------------

static void argv_add_end_marker(argv_t *argv)
{
	utarray_reserve(argv, 1);
	*(char**)_utarray_eltptr(argv, argv_len(argv)) = NULL;
}

argv_t *argv_new()
{
	argv_t *argv;
	utarray_new(argv, &ut_str_icd);
	argv_add_end_marker(argv);

	return argv;
}

void argv_free(argv_t *argv)
{
	utarray_free(argv);
}

void argv_clear(argv_t *argv)
{
	utarray_clear(argv);
	argv_add_end_marker(argv);
}

void argv_push(argv_t *argv, const char *str)
{
	utarray_push_back(argv, &str);
	argv_add_end_marker(argv);
}

void argv_pop(argv_t *argv)
{
	if (utarray_len(argv) > 0)
		utarray_pop_back(argv);
	argv_add_end_marker(argv);
}

void argv_shift(argv_t *argv)
{
	if (utarray_len(argv) > 0) 
		utarray_erase(argv, 0, 1);
	argv_add_end_marker(argv);
}

void argv_unshift(argv_t *argv, const char *str)
{
	utarray_insert(argv, &str, 0);
	argv_add_end_marker(argv);
}

void argv_insert(argv_t *argv, size_t idx, const char *str)
{
	if (idx < argv_len(argv))
		utarray_insert(argv, &str, idx);
	else
		argv_set(argv, idx, str);
	argv_add_end_marker(argv);
}

void argv_erase(argv_t * argv, size_t pos, size_t len)
{
	if (pos + len > utarray_len(argv))
		len = utarray_len(argv) - pos;
	if (pos < utarray_len(argv))
		utarray_erase(argv, pos, len);
	argv_add_end_marker(argv);
}

static int argv_cmp(const void *a, const void *b)
{
	const char *_a = *(const char**)a;
	const char *_b = *(const char**)b;
	return strcmp(_a, _b);
}

void argv_sort(argv_t *argv)
{
	utarray_sort(argv, argv_cmp);
}

char *argv_get(argv_t *argv, size_t idx)
{
	char **elt = argv_eltptr(argv, idx);
	if (elt)
		return *elt;
	else
		return NULL;
}

void argv_set(argv_t *argv, size_t idx, const char *str)
{
	// expand array if needed
	size_t curlen = utarray_len(argv);
	size_t newlen = idx + 1;
	if (newlen > curlen) {
		utarray_reserve(argv, newlen + 1 - curlen);		// +1 for end marker
		memset(_utarray_eltptr(argv, curlen),
			0,
			(char*)_utarray_eltptr(argv, newlen) - (char*)_utarray_eltptr(argv, curlen));
		utarray_len(argv) = newlen;
	}

	// free old element and set new one
	char **elt = argv_eltptr(argv, idx);
	xassert(elt);
	xfree(*elt);
	*elt = xstrdup(str);
	argv_add_end_marker(argv);
}

