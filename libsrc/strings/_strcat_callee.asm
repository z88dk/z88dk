; char *strcat(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

MODULE _strcat_callee_sdcc
GLOBAL _strcat_callee
GLOBAL strcat_callee

defc _strcat_callee = strcat_callee

