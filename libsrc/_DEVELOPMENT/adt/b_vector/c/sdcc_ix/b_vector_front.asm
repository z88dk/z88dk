
; int b_vector_front(b_vector_t *v)

PUBLIC _b_vector_front

EXTERN _b_array_front

_b_vector_front:

   jp _b_array_front

   INCLUDE "adt/b_vector/z80/asm_b_vector_front.asm"
