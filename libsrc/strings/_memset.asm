; void *memset(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memset_sdcc
GLOBAL _memset
GLOBAL memset

defc _memset = memset

