
; void *w_vector_data_fastcall(b_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_data_fastcall

EXTERN asm_w_vector_data

defc _w_vector_data_fastcall = asm_w_vector_data
