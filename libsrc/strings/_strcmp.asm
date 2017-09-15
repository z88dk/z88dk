; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strcmp_sdcc
GLOBAL _strcmp
GLOBAL strcmp

defc _strcmp = strcmp

