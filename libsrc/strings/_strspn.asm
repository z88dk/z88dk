; size_t strspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strspn_sdcc
GLOBAL _strspn
GLOBAL strspn

defc _strspn = strspn

