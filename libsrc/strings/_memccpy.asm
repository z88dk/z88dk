; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memccpy_sdcc
GLOBAL _memccpy
GLOBAL memccpy

defc _memccpy = memccpy

