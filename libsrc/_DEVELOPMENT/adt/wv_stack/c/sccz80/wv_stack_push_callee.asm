
; int wv_stack_push(wv_stack_t *s, void *item)

SECTION seg_code_wv_stack

PUBLIC wv_stack_push_callee

EXTERN w_vector_append_callee

defc wv_stack_push_callee = w_vector_append_callee

INCLUDE "adt/wv_stack/z80/asm_wv_stack_push.asm"
