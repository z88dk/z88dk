
; size_t wv_stack_capacity(wv_stack_t *s)

XDEF _wv_stack_capacity

LIB _w_vector_capacity

_wv_stack_capacity:

   jp _w_vector_capacity

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_capacity.asm"
