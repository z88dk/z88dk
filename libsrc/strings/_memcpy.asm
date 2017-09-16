; void *memcpy(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memcpy_sdcc
GLOBAL _memcpy
GLOBAL memcpy

defc _memcpy = memcpy

