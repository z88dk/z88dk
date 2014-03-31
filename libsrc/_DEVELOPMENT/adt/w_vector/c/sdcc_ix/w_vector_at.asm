
; void *w_vector_at(b_vector_t *v, size_t idx)

XLIB w_vector_at

LIB w_array_at

w_vector_at:

   jp w_array_at

   INCLUDE "adt/w_vector/z80/asm_w_vector_at.asm"
