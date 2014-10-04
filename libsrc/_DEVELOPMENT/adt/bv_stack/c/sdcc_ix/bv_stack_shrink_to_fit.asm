
; int bv_stack_shrink_to_fit(bv_stack_t *s)

SECTION seg_code_bv_stack

PUBLIC _bv_stack_shrink_to_fit

EXTERN _b_vector_shrink_to_fit

defc _bv_stack_shrink_to_fit = _b_vector_shrink_to_fit

INCLUDE "adt/bv_stack/z80/asm_bv_stack_shrink_to_fit.asm"
