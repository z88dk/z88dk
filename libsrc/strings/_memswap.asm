; void *memswap(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memswap_sdcc
GLOBAL _memswap
GLOBAL memswap

defc _memswap = memswap

