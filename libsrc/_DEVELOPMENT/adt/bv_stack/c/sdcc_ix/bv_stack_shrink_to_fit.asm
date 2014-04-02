
; int bv_stack_shrink_to_fit(bv_stack_t *s)

XDEF _bv_stack_shrink_to_fit

LIB _b_vector_shrink_to_fit

_bv_stack_shrink_to_fit:

   jp _b_vector_shrink_to_fit

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_shrink_to_fit.asm"
