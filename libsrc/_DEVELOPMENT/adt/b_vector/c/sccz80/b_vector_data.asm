
; void *b_vector_data(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_data

EXTERN asm_b_vector_data

defc b_vector_data = asm_b_vector_data
