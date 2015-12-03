
; int b_vector_at(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_at

EXTERN b_array_at

defc b_vector_at = b_array_at
