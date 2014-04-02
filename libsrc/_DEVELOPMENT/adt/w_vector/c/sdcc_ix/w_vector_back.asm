
; void *w_vector_back(b_vector_t *v)

XDEF _w_vector_back

LIB _w_array_back

_w_vector_back:

   jp _w_array_back

   INCLUDE "adt/w_vector/z80/asm_w_vector_back.asm"
