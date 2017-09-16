; int strnicmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strnicmp_sdcc
GLOBAL _strnicmp
GLOBAL strnicmp

defc _strnicmp = strnicmp

