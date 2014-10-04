
; int wv_stack_push(wv_stack_t *s, void *item)

SECTION seg_code_wv_stack

PUBLIC _wv_stack_push

EXTERN _w_vector_append

defc _wv_stack_push = _w_vector_append

INCLUDE "adt/wv_stack/z80/asm_wv_stack_push.asm"
