; size_t strxfrm(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strxfrm_callee_sdcc
GLOBAL _strxfrm_callee
GLOBAL strxfrm_callee

defc _strxfrm_callee = strxfrm_callee

