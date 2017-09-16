; int memcmp(const void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memcmp_sdcc
GLOBAL _memcmp
GLOBAL memcmp

defc _memcmp = memcmp

