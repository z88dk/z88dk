
; int wv_stack_shrink_to_fit(wv_stack_t *s)

XDEF _wv_stack_shrink_to_fit

LIB _b_vector_shrink_to_fit

_wv_stack_shrink_to_fit:

   jp _b_vector_shrink_to_fit

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_shrink_to_fit.asm"
