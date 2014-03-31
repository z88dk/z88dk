
; int b_vector_back(b_vector_t *v)

XDEF b_vector_back

LIB b_array_back

b_vector_back:

   jp b_array_back

   INCLUDE "adt/b_vector/z80/asm_b_vector_back.asm"
