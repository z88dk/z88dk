
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_erase_range

EXTERN _b_array_erase_range

defc _b_vector_erase_range = _b_array_erase_range
