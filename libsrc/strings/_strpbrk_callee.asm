; char *strpbrk(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strpbrk_callee_sdcc
GLOBAL _strpbrk_callee
GLOBAL strpbrk_callee

defc _strpbrk_callee = strpbrk_callee

