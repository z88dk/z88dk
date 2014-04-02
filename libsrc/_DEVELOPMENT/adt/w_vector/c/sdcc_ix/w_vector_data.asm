
; void *w_vector_data(b_vector_t *v)

XDEF _w_vector_data

LIB _w_array_data

_w_vector_data:

   jp _w_array_data

   INCLUDE "adt/w_vector/z80/asm_w_vector_data.asm"
