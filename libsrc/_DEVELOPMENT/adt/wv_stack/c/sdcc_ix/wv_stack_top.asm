
; void *wv_stack_top(wv_stack_t *s)

XDEF _wv_stack_top

LIB _w_array_back

_wv_stack_top:

   jp _w_array_back

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_top.asm"
