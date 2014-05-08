
; int wv_stack_empty(wv_stack_t *s)

PUBLIC _wv_stack_empty

EXTERN _w_vector_empty

_wv_stack_empty:

   jp _w_vector_empty

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_empty.asm"
