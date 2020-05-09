//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------
#include "utils.h"
#include "zutils.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void* check_mem(void* p) {
	if (!p) {
		fprintf(stderr, "Out of memory\n");
		exit(EXIT_FAILURE);
	}
	return p;
}

char* safe_strdup(const char* str) {
	return check_mem(strdup(str));
}

char* safe_strdup_n(const char* str, size_t n) {
	char* dst = check_mem(malloc(n + 1));
	strncpy(dst, str, n);
	dst[n] = '\0';
	return dst;
}

void* safe_calloc(size_t number, size_t size) {
	return check_mem(calloc(number, size));
}

FILE* safe_fopen(const char* filename, const char* mode) {
	FILE* fp = fopen(filename, mode);
	if (!fp) {
		fprintf(stderr, "Cannot open %s\n", filename);
		exit(EXIT_FAILURE);
	}
	return fp;
}

void remove_ext(UT_string* dst, const char* src) {
	const char* p = src + strlen(src);
	while (p > src && isalnum(p[-1])) p--;
	if (p > src && p[-1] == '.') p--;
	utstr_set_n(dst, src, p - src);
}
