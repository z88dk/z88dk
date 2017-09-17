; size_t b_array_write_block(void *src, size_t n, b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _b_array_write_block_callee_sdcc
GLOBAL _b_array_write_block_callee
GLOBAL b_array_write_block_callee

defc _b_array_write_block_callee = b_array_write_block_callee

