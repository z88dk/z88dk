
; size_t b_vector_erase(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_erase

EXTERN _b_array_erase

defc _b_vector_erase = _b_array_erase
