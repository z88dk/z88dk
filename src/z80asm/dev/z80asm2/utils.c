#------------------------------------------------------------------------------
# z80asm restart
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
#include "utils.h"

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

FILE* safe_fopen(const char* filename, const char* mode) {
	FILE* fp = fopen(filename, mode);
	if (!fp) {
		fprintf(stderr, "Cannot open %s\n", filename);
		exit(EXIT_FAILURE);
	}
	return fp;
}

bool utstring_fgets(UT_string* str, FILE* fp) {
	int c1, c2;
	utstring_clear(str); utstring_reserve(str, BUFSIZ);
	while ((c1 = getc(fp)) != EOF && c1 != '\n' && c1 != '\r')
		utstring_printf(str, "%c", c1);
	if (c1 == EOF) {
		if (utstring_len(str) > 0)
			utstring_printf(str, "\n");		// add missing newline
	} 
	else {
		utstring_printf(str, "\n");			// add end of line
		if (c1 == '\r' && (c2 = getc(fp)) != EOF && c2 != '\n')
			ungetc(c2, fp);					// push back to input
	}
	return utstring_len(str) > 0 ? true : false;
}

void remove_ext(UT_string* dst, const char* src) {
	const char* p = src + strlen(src);
	while (p > src && isalnum(p[-1])) p--;
	if (p > src && p[-1] == '.') p--;
	utstring_clear(dst); utstring_bincpy(dst, src, p - src);
}
