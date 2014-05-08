
; size_t w_vector_erase(w_vector_t *v, size_t idx)

PUBLIC _w_vector_erase

EXTERN _w_array_erase

_w_vector_erase:

   jp _w_array_erase

   INCLUDE "adt/w_vector/z80/asm_w_vector_erase.asm"
