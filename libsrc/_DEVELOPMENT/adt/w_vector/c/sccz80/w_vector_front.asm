
; void *w_vector_front(w_vector_t *v)

SECTION code_adt_w_vector

PUBLIC w_vector_front

defc w_vector_front = asm_w_vector_front

INCLUDE "adt/w_vector/z80/asm_w_vector_front.asm"
