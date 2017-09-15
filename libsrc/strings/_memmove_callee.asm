; void *memmove(void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memmove_callee_sdcc
GLOBAL _memmove_callee
GLOBAL memmove_callee

defc _memmove_callee = memmove_callee

