
; int wv_stack_reserve(wv_stack_t *s, size_t n)

XDEF wv_stack_reserve

LIB w_vector_reserve

wv_stack_reserve:

   jp w_vector_reserve

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_reserve.asm"
