; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

MODULE _strnchr_callee_sdcc
GLOBAL _strnchr_callee
GLOBAL strnchr_callee

defc _strnchr_callee = strnchr_callee

