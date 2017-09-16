; char *strchr(const char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _strchr_sdcc
GLOBAL _strchr
GLOBAL strchr

defc _strchr = strchr

