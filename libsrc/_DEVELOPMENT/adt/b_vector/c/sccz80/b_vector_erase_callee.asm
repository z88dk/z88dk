
; size_t b_vector_erase(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_erase_callee

EXTERN b_array_erase_callee

defc b_vector_erase_callee = b_array_erase_callee
