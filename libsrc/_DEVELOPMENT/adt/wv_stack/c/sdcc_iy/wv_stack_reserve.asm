
; int wv_stack_reserve(wv_stack_t *s, size_t n)

PUBLIC _wv_stack_reserve

EXTERN _w_vector_reserve

_wv_stack_reserve:

   jp _w_vector_reserve

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_reserve.asm"
