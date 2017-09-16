; int strcasecmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strcasecmp_sdcc
GLOBAL _strcasecmp
GLOBAL strcasecmp

defc _strcasecmp = strcasecmp

