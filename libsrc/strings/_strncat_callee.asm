; char *strncat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strncat_callee_sdcc
GLOBAL _strncat_callee
GLOBAL strncat_callee

defc _strncat_callee = strncat_callee

