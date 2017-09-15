; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strncpy_sdcc
GLOBAL _strncpy
GLOBAL strncpy

defc _strncpy = strncpy

