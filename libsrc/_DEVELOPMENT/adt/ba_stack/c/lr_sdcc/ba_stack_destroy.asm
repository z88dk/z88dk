
; void ba_stack_destroy(ba_stack_t *s)

XDEF ba_stack_destroy

LIB b_array_destroy

defc ba_stack_destroy = b_array_destroy

INCLUDE "../../z80/asm_ba_stack_destroy.asm"
