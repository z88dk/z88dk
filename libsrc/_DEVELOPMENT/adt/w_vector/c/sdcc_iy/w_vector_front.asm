
; void *w_vector_front(w_vector_t *v)

XDEF _w_vector_front

LIB _w_array_front

_w_vector_front:

   jp _w_array_front

   INCLUDE "adt/w_vector/z80/asm_w_vector_front.asm"
