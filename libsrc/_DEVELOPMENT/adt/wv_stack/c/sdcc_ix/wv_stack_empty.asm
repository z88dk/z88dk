
; int wv_stack_empty(wv_stack_t *s)

XDEF _wv_stack_empty

LIB _w_vector_empty

_wv_stack_empty:

   jp _w_vector_empty

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_empty.asm"
