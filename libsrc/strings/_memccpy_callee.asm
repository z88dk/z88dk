; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memccpy_callee_sdcc
GLOBAL _memccpy_callee
GLOBAL memccpy_callee

defc _memccpy_callee = memccpy_callee

