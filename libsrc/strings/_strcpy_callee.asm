; char *strcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

MODULE _strcpy_callee_sdcc
GLOBAL _strcpy_callee
GLOBAL strcpy_callee

defc _strcpy_callee = strcpy_callee

