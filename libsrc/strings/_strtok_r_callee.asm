; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)

SECTION code_clib
SECTION code_string

MODULE _strtok_r_callee_sdcc
GLOBAL _strtok_r_callee
GLOBAL strtok_r_callee

defc _strtok_r_callee = strtok_r_callee

