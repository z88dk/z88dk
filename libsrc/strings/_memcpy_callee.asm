; void *memcpy(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memcpy_callee_sdcc
GLOBAL _memcpy_callee
GLOBAL memcpy_callee

defc _memcpy_callee = memcpy_callee

