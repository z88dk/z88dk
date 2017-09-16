; char *strchrnul(const char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _strchrnul_callee_sdcc
GLOBAL _strchrnul_callee
GLOBAL strchrnul_callee

defc _strchrnul_callee = strchrnul_callee

