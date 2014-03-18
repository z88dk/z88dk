
; int bv_stack_shrink_to_fit(bv_stack_t *s)

XDEF bv_stack_shrink_to_fit

LIB b_vector_shrink_to_fit

defc bv_stack_shrink_to_fit = b_vector_shrink_to_fit

INCLUDE "../../z80/asm_bv_stack_shrink_to_fit.asm"
