//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2022
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "die.h"
#include "strutil.h"
#include "uthash.h"
#include "utstring.h"
#include <ctype.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdlib.h>

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
			_utarray_eltptr(argv, newlen) - _utarray_eltptr(argv, curlen));
		utarray_len(argv) = newlen;
	}

	// free old element and set new one
	char **elt = argv_eltptr(argv, idx);
	xassert(elt);
	xfree(*elt);
	*elt = xstrdup(str);
	argv_add_end_marker(argv);
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
		xfree(elem->str);
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

const char *spool_add_n(const char *str, size_t n) {
	char* copy = xmalloc(n + 1);
	strncpy(copy, str, n);
	copy[n] = '\0';
	const char* ret = spool_add(copy);
	xfree(copy);
	return ret;
}
