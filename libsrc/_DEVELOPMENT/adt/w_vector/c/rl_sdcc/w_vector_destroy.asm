
; void w_vector_destroy(w_vector_t *v)

XDEF w_vector_destroy

LIB b_vector_destroy

defc w_vector_destroy = b_vector_destroy

INCLUDE "adt/w_vector/z80/asm_w_vector_destroy.asm"
