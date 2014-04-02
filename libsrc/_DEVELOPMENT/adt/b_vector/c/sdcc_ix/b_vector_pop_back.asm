
; int b_vector_pop_back(b_vector_t *v)

XDEF _b_vector_pop_back

LIB _b_array_pop_back

_b_vector_pop_back:

   jp _b_array_pop_back

   INCLUDE "adt/b_vector/z80/asm_b_vector_pop_back.asm"
