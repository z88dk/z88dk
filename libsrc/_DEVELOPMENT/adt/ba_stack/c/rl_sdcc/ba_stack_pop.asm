
; int ba_stack_pop(ba_stack_t *s)

XDEF ba_stack_pop

LIB b_array_pop_back

defc ba_stack_pop = b_array_pop_back

INCLUDE "../../z80/asm_ba_stack_pop.asm"
