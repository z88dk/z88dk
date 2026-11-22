
; void *b_vector_size(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_size

EXTERN _b_array_size

defc _b_vector_size = _b_array_size
