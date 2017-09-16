; char *strcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

MODULE _strcpy_sdcc
GLOBAL _strcpy
GLOBAL strcpy

defc _strcpy = strcpy

