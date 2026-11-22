
; int b_vector_front(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_front

EXTERN _b_array_front

defc _b_vector_front = _b_array_front
