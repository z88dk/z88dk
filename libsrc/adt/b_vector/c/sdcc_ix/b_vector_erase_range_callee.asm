
; size_t b_vector_erase_range_callee(b_vector_t *v, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_erase_range_callee

EXTERN _b_array_erase_range_callee

defc _b_vector_erase_range_callee = _b_array_erase_range_callee
