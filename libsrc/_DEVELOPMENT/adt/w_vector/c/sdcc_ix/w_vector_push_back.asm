
; size_t w_vector_push_back(w_vector_t *v, int c)

XDEF _w_vector_push_back

LIB _w_vector_append

_w_vector_push_back:

   jp _w_vector_append

   INCLUDE "adt/w_vector/z80/asm_w_vector_push_back.asm"
