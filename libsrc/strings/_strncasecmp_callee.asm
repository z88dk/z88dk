; int strncasecmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strncasecmp_callee_sdcc
GLOBAL _strncasecmp_callee
GLOBAL strncasecmp_callee

defc _strncasecmp_callee = strncasecmp_callee

