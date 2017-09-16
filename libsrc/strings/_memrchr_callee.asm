; void *memrchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memrchr_callee_sdcc
GLOBAL _memrchr_callee
GLOBAL memrchr_callee

defc _memrchr_callee = memrchr_callee

