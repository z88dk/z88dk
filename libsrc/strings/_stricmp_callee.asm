; int stricmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _stricmp_callee_sdcc
GLOBAL _stricmp_callee
GLOBAL stricmp_callee

defc _stricmp_callee = stricmp_callee

