
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_erase_range_callee

EXTERN b_array_erase_range_callee

defc b_vector_erase_range_callee = b_array_erase_range_callee
