
; int b_vector_front(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC b_vector_front

defc b_vector_front = asm_b_vector_front

INCLUDE "adt/b_vector/z80/asm_b_vector_front.asm"
