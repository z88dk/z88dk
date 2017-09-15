; int strncmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strncmp_sdcc
GLOBAL _strncmp
GLOBAL strncmp

defc _strncmp = strncmp

