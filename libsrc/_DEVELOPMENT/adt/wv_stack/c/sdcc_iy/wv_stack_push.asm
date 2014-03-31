
; int wv_stack_push(wv_stack_t *s, void *item)

XDEF wv_stack_push

LIB w_vector_append

wv_stack_push:

   jp w_vector_append

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_push.asm"
