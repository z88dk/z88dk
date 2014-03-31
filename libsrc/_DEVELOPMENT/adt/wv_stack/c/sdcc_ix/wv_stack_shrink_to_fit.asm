
; int wv_stack_shrink_to_fit(wv_stack_t *s)

XDEF wv_stack_shrink_to_fit

LIB b_vector_shrink_to_fit

wv_stack_shrink_to_fit:

   jp b_vector_shrink_to_fit

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_shrink_to_fit.asm"
