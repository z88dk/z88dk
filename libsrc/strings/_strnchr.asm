; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

MODULE _strnchr_sdcc
GLOBAL _strnchr
GLOBAL strnchr

defc _strnchr = strnchr

