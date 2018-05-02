//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "strutil.h"
#include "die.h"
#include "uthash.h"
#include <stdarg.h>
#include <stdbool.h>
#include <stdlib.h>

//-----------------------------------------------------------------------------
// string str_t
//-----------------------------------------------------------------------------
str_t *str_new()
{
	str_t *str;
	utstring_new(str);
	return str;
}

str_t *str_new_copy(const char *src)
{
	str_t *str = str_new();
	str_set(str, src);
	return str;
}

void str_free(str_t *str)
{
	utstring_free(str);
}

void str_clear(str_t *str)
{
	utstring_clear(str);
}

void str_reserve(str_t *str, size_t amt)
{
	utstring_reserve(str, amt);
}

void str_set(str_t *str, const char *src)
{
	utstring_clear(str);
	utstring_bincpy(str, src, strlen(src));
}

void str_set_f(str_t *str, const char *fmt, ...)
{
	utstring_clear(str);
	va_list ap;
	va_start(ap, fmt);
	utstring_printf_va(str, fmt, ap);
	va_end(ap);
}

void str_set_bin(str_t *str, const char *data, size_t len)
{
	utstring_clear(str);
	utstring_bincpy(str, data, len);
}

void str_set_str(str_t *str, str_t *src)
{
	utstring_clear(str);
	utstring_concat(str, src);
}

void str_append(str_t *str, const char *src)
{
	utstring_bincpy(str, src, strlen(src));
}

void str_append_f(str_t *str, const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	utstring_printf_va(str, fmt, ap);
	va_end(ap);
}

void str_append_bin(str_t *str, const char *data, size_t len)
{
	utstring_bincpy(str, data, len);
}

void str_append_str(str_t *str, str_t *src)
{
	utstring_concat(str, src);
}

//-----------------------------------------------------------------------------
// string pool
//-----------------------------------------------------------------------------
typedef struct spool_s {
	char *str;
	UT_hash_handle hh;
} spool_t;

static spool_t *spool = NULL;

static void spool_deinit(void);

static void spool_init()
{
	static bool inited = false;
	if (!inited) {
		inited = true;
		atexit(spool_deinit);
	}
}

static void spool_deinit(void)
{
	spool_t *elem, *tmp;
	HASH_ITER(hh, spool, elem, tmp) {
		HASH_DEL(spool, elem);
		xfree(elem);
	}
}

const char *spool_add(const char *str)
{
	spool_init();

	if (str == NULL) return NULL;		// special case

	spool_t *found;
	HASH_FIND_STR(spool, str, found);
	if (found) return found->str;		// found

	found = xnew(spool_t);
	found->str = xstrdup(str);

	HASH_ADD_STR(spool, str, found);

	return found->str;
}

