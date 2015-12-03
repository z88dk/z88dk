
; void *b_vector_size(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_size

EXTERN asm_b_vector_size

defc b_vector_size = asm_b_vector_size
