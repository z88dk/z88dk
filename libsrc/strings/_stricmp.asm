; int stricmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _stricmp_sdcc
GLOBAL _stricmp
GLOBAL stricmp

defc _stricmp = stricmp

