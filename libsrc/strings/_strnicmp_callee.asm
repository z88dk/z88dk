; int strnicmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strnicmp_callee_sdcc
GLOBAL _strnicmp_callee
GLOBAL strnicmp_callee

defc _strnicmp_callee = strnicmp_callee

