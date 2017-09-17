; size_t b_array_erase_range(b_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_string

MODULE _b_array_erase_range_callee_sdcc
GLOBAL _b_array_erase_range_callee
GLOBAL b_array_erase_range_callee

defc _b_array_erase_range_callee = b_array_erase_range_callee

