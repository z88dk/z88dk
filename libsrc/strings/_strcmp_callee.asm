; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strcmp_callee_sdcc
GLOBAL _strcmp_callee
GLOBAL strcmp_callee

defc _strcmp_callee = strcmp_callee

