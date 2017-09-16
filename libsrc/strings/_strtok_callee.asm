; char *strtok(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

MODULE _strtok_callee_sdcc
GLOBAL _strtok_callee
GLOBAL strtok_callee

defc _strtok_callee = strtok_callee

