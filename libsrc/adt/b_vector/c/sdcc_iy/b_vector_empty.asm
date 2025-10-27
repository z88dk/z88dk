
; void b_vector_empty(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_empty

EXTERN _b_array_empty

defc _b_vector_empty = _b_array_empty
