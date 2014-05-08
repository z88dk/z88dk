
; void wv_stack_clear(wv_stack_t *s)

PUBLIC _wv_stack_clear

EXTERN _w_vector_clear

_wv_stack_clear:

   jp _w_vector_clear

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_clear.asm"
