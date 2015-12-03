
; void b_vector_empty(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_empty

EXTERN asm_b_vector_empty

defc b_vector_empty = asm_b_vector_empty
