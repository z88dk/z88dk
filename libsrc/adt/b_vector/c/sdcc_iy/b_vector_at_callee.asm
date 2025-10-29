
; int b_vector_at_callee(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_at_callee

EXTERN _b_array_at_callee

defc _b_vector_at_callee = _b_array_at_callee
