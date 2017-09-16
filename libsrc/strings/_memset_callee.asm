; void *memset(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memset_callee_sdcc
GLOBAL _memset_callee
GLOBAL memset_callee

defc _memset_callee = memset_callee

