
; int b_vector_front(b_vector_t *v)

XDEF b_vector_front

LIB b_array_front

b_vector_front:

   jp b_array_front

   INCLUDE "adt/b_vector/z80/asm_b_vector_front.asm"
