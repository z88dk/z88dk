; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)

SECTION code_clib
SECTION code_string

MODULE _memmem_callee_sdcc
GLOBAL _memmem_callee
GLOBAL memmem_callee

defc _memmem_callee = memmem_callee

