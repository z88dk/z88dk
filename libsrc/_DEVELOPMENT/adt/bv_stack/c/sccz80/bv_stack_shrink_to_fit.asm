
; int bv_stack_shrink_to_fit(bv_stack_t *s)

SECTION seg_code_bv_stack

PUBLIC bv_stack_shrink_to_fit

defc bv_stack_shrink_to_fit = asm_bv_stack_shrink_to_fit

INCLUDE "adt/bv_stack/z80/asm_bv_stack_shrink_to_fit.asm"
