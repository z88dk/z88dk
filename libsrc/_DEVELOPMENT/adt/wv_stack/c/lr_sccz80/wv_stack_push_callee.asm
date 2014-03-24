
; int wv_stack_push(wv_stack_t *s, void *item)

XDEF wv_stack_push_callee

LIB w_vector_append_callee

;defc wv_stack_push_callee = w_vector_append_callee

w_stack_push_callee:

   jp w_vector_append_callee

INCLUDE "adt/wv_stack/z80/asm_wv_stack_push.asm"
