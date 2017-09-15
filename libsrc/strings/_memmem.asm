; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)

SECTION code_clib
SECTION code_string

MODULE _memmem_sdcc
GLOBAL _memmem
GLOBAL memmem

defc _memmem = memmem

