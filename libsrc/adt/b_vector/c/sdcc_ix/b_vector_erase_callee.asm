
; size_t b_vector_erase_callee(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_erase_callee

EXTERN _b_array_erase_callee

defc _b_vector_erase_callee = _b_array_erase_callee
