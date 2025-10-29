
; int b_vector_back(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_back

EXTERN _b_array_back

defc _b_vector_back = _b_array_back
