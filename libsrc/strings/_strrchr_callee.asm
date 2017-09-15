; char *strrchr(const char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _strrchr_callee_sdcc
GLOBAL _strrchr_callee
GLOBAL strrchr_callee

defc _strrchr_callee = strrchr_callee

