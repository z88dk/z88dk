
; size_t ba_stack_size(ba_stack_t *s)

XDEF ba_stack_size

defc ba_stack_size = asm_ba_stack_size

INCLUDE "../../z80/asm_ba_stack_size.asm"
