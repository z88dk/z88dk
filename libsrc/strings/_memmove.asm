; void *memmove(void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _memmove_sdcc
GLOBAL _memmove
GLOBAL memmove

defc _memmove = memmove

