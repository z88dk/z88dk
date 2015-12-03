
; void *w_vector_data(b_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_data

EXTERN asm_w_vector_data

defc w_vector_data = asm_w_vector_data
