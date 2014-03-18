
; int bv_stack_pop(bv_stack_t *s)

XDEF bv_stack_pop

defc bv_stack_pop = asm_bv_stack_pop

INCLUDE "../../z80/asm_bv_stack_pop.asm"
