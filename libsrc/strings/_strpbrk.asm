; char *strpbrk(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strpbrk_sdcc
GLOBAL _strpbrk
GLOBAL strpbrk

defc _strpbrk = strpbrk

