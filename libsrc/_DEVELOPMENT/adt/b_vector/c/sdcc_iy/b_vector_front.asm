
; int b_vector_front(b_vector_t *v)

XDEF _b_vector_front

LIB _b_array_front

_b_vector_front:

   jp _b_array_front

   INCLUDE "adt/b_vector/z80/asm_b_vector_front.asm"
