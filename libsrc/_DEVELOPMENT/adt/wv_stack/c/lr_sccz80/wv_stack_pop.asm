
; void *wv_stack_pop(wv_stack_t *s)

XDEF wv_stack_pop

defc wv_stack_pop = asm_wv_stack_pop

INCLUDE "../../z80/asm_wv_stack_pop.asm"
