; char *stpncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _stpncpy_sdcc
GLOBAL _stpncpy
GLOBAL stpncpy

defc _stpncpy = stpncpy

