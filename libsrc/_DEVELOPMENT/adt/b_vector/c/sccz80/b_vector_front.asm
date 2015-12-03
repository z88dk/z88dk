
; int b_vector_front(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_front

EXTERN asm_b_vector_front

defc b_vector_front = asm_b_vector_front
