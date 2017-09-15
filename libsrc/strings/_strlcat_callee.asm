; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strlcat_callee_sdcc
GLOBAL _strlcat_callee
GLOBAL strlcat_callee

defc _strlcat_callee = strlcat_callee

