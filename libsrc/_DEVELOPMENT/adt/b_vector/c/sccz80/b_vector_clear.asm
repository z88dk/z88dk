
; void b_vector_clear(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_clear

EXTERN asm_b_vector_clear

defc b_vector_clear = asm_b_vector_clear
