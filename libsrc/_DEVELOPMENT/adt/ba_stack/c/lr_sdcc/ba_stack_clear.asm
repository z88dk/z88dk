
; void ba_stack_clear(ba_stack_t *s)

XDEF ba_stack_clear

LIB b_array_clear

defc ba_stack_clear = b_array_clear

INCLUDE "../../asm_ba_stack_clear.asm"
