
; void *w_vector_front(w_vector_t *v)

SECTION code_adt_w_vector

PUBLIC _w_vector_front

EXTERN _w_array_front

defc _w_vector_front = _w_array_front

INCLUDE "adt/w_vector/z80/asm_w_vector_front.asm"
