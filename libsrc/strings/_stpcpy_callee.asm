; char *stpcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

MODULE _stpcpy_callee_sdcc
GLOBAL _stpcpy_callee
GLOBAL stpcpy_callee

defc _stpcpy_callee = stpcpy_callee

