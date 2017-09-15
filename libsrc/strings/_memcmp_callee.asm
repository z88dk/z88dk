; int memcmp(const void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memcmp_callee_sdcc
GLOBAL _memcmp_callee
GLOBAL memcmp_callee

defc _memcmp_callee = memcmp_callee

