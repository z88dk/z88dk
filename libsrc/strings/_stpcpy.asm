; char *stpcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

MODULE _stpcpy_sdcc
GLOBAL _stpcpy
GLOBAL stpcpy

defc _stpcpy = stpcpy

