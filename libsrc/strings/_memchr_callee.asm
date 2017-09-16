; void *memchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memchr_callee_sdcc
GLOBAL _memchr_callee
GLOBAL memchr_callee

defc _memchr_callee = memchr_callee

