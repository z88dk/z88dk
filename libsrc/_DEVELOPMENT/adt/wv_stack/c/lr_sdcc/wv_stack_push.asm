
; int wv_stack_push(wv_stack_t *s, void *item)

XDEF wv_stack_push

LIB w_vector_append

defc wv_stack_push = w_vector_append

INCLUDE "../../z80/asm_wv_stack_push.asm"
