
; void wv_stack_destroy(wv_stack_t *s)

PUBLIC _wv_stack_destroy

EXTERN _w_vector_destroy

_wv_stack_destroy:

   jp _w_vector_destroy

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_destroy.asm"
