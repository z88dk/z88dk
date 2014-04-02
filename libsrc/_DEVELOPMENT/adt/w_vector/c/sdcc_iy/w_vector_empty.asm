
; void w_vector_empty(w_vector_t *v)

XDEF _w_vector_empty

LIB _w_array_empty

_w_vector_empty:

   jp _w_array_empty

   INCLUDE "adt/w_vector/z80/asm_w_vector_empty.asm"
