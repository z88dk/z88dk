
; int b_vector_at(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_at

EXTERN _b_array_at

defc _b_vector_at = _b_array_at
