
; int w_vector_shrink_to_fit(w_vector_t *v)

XDEF w_vector_shrink_to_fit

LIB b_vector_shrink_to_fit

w_vector_shrink_to_fit:

   jp b_vector_shrink_to_fit

   INCLUDE "adt/w_vector/z80/asm_w_vector_shrink_to_fit.asm"
