
; size_t b_vector_capacity(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_capacity

EXTERN _b_array_capacity

defc _b_vector_capacity = _b_array_capacity
