//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------
#pragma once

#include "utstring.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

void* check_mem(void* p);
char* safe_strdup(const char* str);
char* safe_strdup_n(const char* str, size_t n);
void* safe_calloc(size_t number, size_t size);
FILE* safe_fopen(const char* filename, const char* mode);
bool utstring_fgets(UT_string* str, FILE* fp);
void utstring_set(UT_string* dst, const char* src);
void utstring_set_n(UT_string* dst, const char* src, size_t n);
void utstring_toupper(UT_string* str);
void remove_ext(UT_string* dst, const char* src);
