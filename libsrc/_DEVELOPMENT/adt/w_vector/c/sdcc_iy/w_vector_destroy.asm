
; void w_vector_destroy(w_vector_t *v)

XDEF _w_vector_destroy

LIB _b_vector_destroy

_w_vector_destroy:

   jp _b_vector_destroy

   INCLUDE "adt/w_vector/z80/asm_w_vector_destroy.asm"
