; int strncmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strncmp_callee_sdcc
GLOBAL _strncmp_callee
GLOBAL strncmp_callee

defc _strncmp_callee = strncmp_callee

