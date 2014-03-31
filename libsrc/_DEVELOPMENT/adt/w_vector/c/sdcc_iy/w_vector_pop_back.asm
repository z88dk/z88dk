
; void *w_vector_pop_back(w_vector_t *v)

XDEF w_vector_pop_back

LIB w_array_pop_back

w_vector_pop_back:

   jp w_array_pop_back

   INCLUDE "adt/w_vector/z80/asm_w_vector_pop_back.asm"
