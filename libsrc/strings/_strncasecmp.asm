; int strncasecmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strncasecmp_sdcc
GLOBAL _strncasecmp
GLOBAL strncasecmp

defc _strncasecmp = strncasecmp

