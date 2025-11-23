
; void *b_vector_data_fastcall(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_data_fastcall

EXTERN _b_array_data_fastcall

defc _b_vector_data_fastcall = _b_array_data_fastcall
