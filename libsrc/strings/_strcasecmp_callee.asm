; int strcasecmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strcasecmp_callee_sdcc
GLOBAL _strcasecmp_callee
GLOBAL strcasecmp_callee

defc _strcasecmp_callee = strcasecmp_callee

