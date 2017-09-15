; size_t strspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strspn_callee_sdcc
GLOBAL _strspn_callee
GLOBAL strspn_callee

defc _strspn_callee = strspn_callee

