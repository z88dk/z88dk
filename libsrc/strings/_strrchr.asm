; char *strrchr(const char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _strrchr_sdcc
GLOBAL _strrchr
GLOBAL strrchr

defc _strrchr = strrchr

