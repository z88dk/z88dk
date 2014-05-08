
; size_t w_vector_capacity(w_vector_t *v)

PUBLIC _w_vector_capacity

EXTERN _w_array_capacity

_w_vector_capacity:

   jp _w_array_capacity

   INCLUDE "adt/w_vector/z80/asm_w_vector_capacity.asm"
