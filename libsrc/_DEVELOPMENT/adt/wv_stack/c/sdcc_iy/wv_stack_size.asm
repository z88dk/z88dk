
; size_t wv_stack_size(wv_stack_t *s)

XDEF _wv_stack_size

LIB _w_vector_size

_wv_stack_size:

   jp _w_vector_size

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_size.asm"
