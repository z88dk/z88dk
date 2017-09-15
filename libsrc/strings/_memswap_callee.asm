; void *memswap(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memswap_callee_sdcc
GLOBAL _memswap_callee
GLOBAL memswap_callee

defc _memswap_callee = memswap_callee

