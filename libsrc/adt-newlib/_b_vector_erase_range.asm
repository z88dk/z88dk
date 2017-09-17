; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_string

MODULE _b_vector_erase_range_sdcc
GLOBAL _b_vector_erase_range
GLOBAL b_vector_erase_range

defc _b_vector_erase_range = b_vector_erase_range

