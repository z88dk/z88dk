
; int ba_stack_top(ba_stack_t *s)

XDEF ba_stack_top

LIB b_array_back

defc ba_stack_top = b_array_back

INCLUDE "../../z80/asm_ba_stack_top.asm"
