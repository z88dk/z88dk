
; void w_vector_empty(w_vector_t *v)

XDEF w_vector_empty

LIB w_array_empty

w_vector_empty:

   jp w_array_empty

   INCLUDE "adt/w_vector/z80/asm_w_vector_empty.asm"
