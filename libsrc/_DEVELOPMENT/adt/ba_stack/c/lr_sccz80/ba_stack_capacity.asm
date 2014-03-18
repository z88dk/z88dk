
; size_t ba_stack_capacity(ba_stack_t *s)

XDEF ba_stack_capacity

defc ba_stack_capacity = asm_ba_stack_capacity

INCLUDE "../../z80/asm_ba_stack_capacity.asm"
