
; int b_vector_front(b_vector_t *v)

XDEF b_vector_front

LIB b_array_front

defc b_vector_front = b_array_front

INCLUDE "../../z80/asm_b_vector_front.asm"
