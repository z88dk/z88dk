#pragma once

#include"utstring.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

void* check_mem(void* p);
char* safe_strdup(const char* str);
char* safe_strdup_n(const char* str, size_t n);
FILE* safe_fopen(const char* filename, const char* mode);
bool utstring_fgets(UT_string* str, FILE* fp);
void remove_ext(UT_string* dst, const char* src);
