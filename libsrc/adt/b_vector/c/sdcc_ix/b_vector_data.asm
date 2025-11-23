
; void *b_vector_data(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_data

EXTERN _b_array_data

defc _b_vector_data = _b_array_data
