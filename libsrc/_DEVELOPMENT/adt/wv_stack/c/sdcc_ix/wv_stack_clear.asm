
; void wv_stack_clear(wv_stack_t *s)

XDEF _wv_stack_clear

LIB _w_vector_clear

_wv_stack_clear:

   jp _w_vector_clear

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_clear.asm"
