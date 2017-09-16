; char* strset(char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _strset_callee_sdcc
GLOBAL _strset_callee
GLOBAL strset_callee

defc _strset_callee = strset_callee

