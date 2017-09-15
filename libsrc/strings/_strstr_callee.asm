; char *strstr(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strstr_callee_sdcc
GLOBAL _strstr_callee
GLOBAL strstr_callee

defc _strstr_callee = strstr_callee

