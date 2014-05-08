
; void *w_vector_size(w_vector_t *v)

PUBLIC _w_vector_size

EXTERN _w_array_size

_w_vector_size:

   jp _w_array_size

   INCLUDE "adt/w_vector/z80/asm_w_vector_size.asm"
