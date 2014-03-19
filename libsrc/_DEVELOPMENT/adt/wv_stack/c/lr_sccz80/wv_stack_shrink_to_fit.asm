
; int wv_stack_shrink_to_fit(wv_stack_t *s)

XDEF wv_stack_shrink_to_fit

defc wv_stack_shrink_to_fit = asm_wv_stack_shrink_to_fit

INCLUDE "../../z80/asm_wv_stack_shrink_to_fit.asm"
