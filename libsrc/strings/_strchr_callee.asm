; char *strchr(const char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _strchr_callee_sdcc
GLOBAL _strchr_callee
GLOBAL strchr_callee

defc _strchr_callee = strchr_callee

