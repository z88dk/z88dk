; char *stpncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _stpncpy_callee_sdcc
GLOBAL _stpncpy_callee
GLOBAL stpncpy_callee

defc _stpncpy_callee = stpncpy_callee

