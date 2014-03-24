
; int wv_stack_empty(wv_stack_t *s)

XDEF wv_stack_empty

LIB w_vector_empty

defc wv_stack_empty = w_vector_empty

INCLUDE "adt/wv_stack/z80/asm_wv_stack_empty.asm"
