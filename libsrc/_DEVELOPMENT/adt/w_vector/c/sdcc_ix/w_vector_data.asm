
; void *w_vector_data(b_vector_t *v)

XDEF w_vector_data

LIB w_array_data

w_vector_data:

   jp w_array_data

   INCLUDE "adt/w_vector/z80/asm_w_vector_data.asm"
