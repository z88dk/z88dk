//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "utstring.h"
#include <string.h>

// str_t: alias to UT_string
typedef UT_string str_t;

#define str_data(x) utstring_body(x)
#define str_len(x)  utstring_len(x)

extern str_t *str_new();
extern str_t *str_new_copy(const char *in);
extern void str_free(str_t *str);

extern void str_clear(str_t *str);

extern void str_reserve(str_t *str, size_t amt);

extern void str_set(str_t *str, const char *in);
extern void str_set_f(str_t *str, const char *fmt, ...);
extern void str_set_bin(str_t *str, const char *data, size_t len);

extern void str_append(str_t *str, const char *in);
extern void str_append_f(str_t *str, const char *fmt, ...);
extern void str_append_bin(str_t *str, const char *data, size_t len);

extern void str_concat(str_t *str, str_t *src);
