
; int b_vector_back(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_back_fastcall

EXTERN _b_array_back_fastcall

defc _b_vector_back_fastcall = _b_array_back_fastcall
