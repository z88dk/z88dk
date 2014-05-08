
; int wv_stack_push(wv_stack_t *s, void *item)

PUBLIC _wv_stack_push

EXTERN _w_vector_append

_wv_stack_push:

   jp _w_vector_append

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_push.asm"
