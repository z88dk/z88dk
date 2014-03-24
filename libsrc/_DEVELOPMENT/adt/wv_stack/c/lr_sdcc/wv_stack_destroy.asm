
; void wv_stack_destroy(wv_stack_t *s)

XDEF wv_stack_destroy

LIB w_vector_destroy

defc wv_stack_destroy = w_vector_destroy

INCLUDE "adt/wv_stack/z80/asm_wv_stack_destroy.asm"
