; size_t strxfrm(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strxfrm_sdcc
GLOBAL _strxfrm
GLOBAL strxfrm

defc _strxfrm = strxfrm

