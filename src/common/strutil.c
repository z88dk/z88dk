//-----------------------------------------------------------------------------
// String Utilities - based on UT_string
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "strutil.h"
#include <stdarg.h>
#include <stdlib.h>

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
