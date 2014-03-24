
; void wv_stack_clear(wv_stack_t *s)

XDEF wv_stack_clear

LIB w_vector_clear

defc wv_stack_clear = w_vector_clear

INCLUDE "adt/wv_stack/z80/asm_wv_stack_clear.asm"
