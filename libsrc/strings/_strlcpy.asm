; size_t strlcpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strlcpy_sdcc
GLOBAL _strlcpy
GLOBAL strlcpy

defc _strlcpy = strlcpy

