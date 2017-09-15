; void *memchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memchr_sdcc
GLOBAL _memchr
GLOBAL memchr

defc _memchr = memchr

