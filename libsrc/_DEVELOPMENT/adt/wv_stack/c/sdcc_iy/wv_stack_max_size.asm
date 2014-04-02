
; size_t wv_stack_max_size(wv_stack_t *s)

XDEF _wv_stack_max_size

LIB _w_vector_max_size

_wv_stack_max_size:

   jp _w_vector_max_size

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_size.asm"
