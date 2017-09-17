; size_t b_array_erase_range(b_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_string

MODULE _b_array_erase_range_sdcc
GLOBAL _b_array_erase_range
GLOBAL b_array_erase_range

defc _b_array_erase_range = b_array_erase_range

