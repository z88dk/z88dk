; void *memrchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memrchr_sdcc
GLOBAL _memrchr
GLOBAL memrchr

defc _memrchr = memrchr

