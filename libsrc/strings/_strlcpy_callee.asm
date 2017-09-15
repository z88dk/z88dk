; size_t strlcpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strlcpy_callee_sdcc
GLOBAL _strlcpy_callee
GLOBAL strlcpy_callee

defc _strlcpy_callee = strlcpy_callee

