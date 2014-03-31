
; void w_vector_clear(w_vector_t *v)

XDEF w_vector_clear

LIB w_array_clear

w_vector_clear:

   jp w_array_clear

   INCLUDE "adt/w_vector/z80/asm_w_vector_clear.asm"
