; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strncpy_callee_sdcc
GLOBAL _strncpy_callee
GLOBAL strncpy_callee

defc _strncpy_callee = strncpy_callee

