
; int w_vector_shrink_to_fit(w_vector_t *v)

PUBLIC _w_vector_shrink_to_fit

EXTERN _b_vector_shrink_to_fit

_w_vector_shrink_to_fit:

   jp _b_vector_shrink_to_fit

   INCLUDE "adt/w_vector/z80/asm_w_vector_shrink_to_fit.asm"
