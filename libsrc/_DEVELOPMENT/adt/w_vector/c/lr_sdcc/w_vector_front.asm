
; void *w_vector_front(w_vector_t *v)

XDEF w_vector_front

LIB w_array_front

defc w_vector_front = w_array_front

INCLUDE "adt/w_vector/z80/asm_w_vector_front.asm"
