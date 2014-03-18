
; size_t ba_stack_size(ba_stack_t *s)

XDEF ba_stack_size

LIB b_array_size

defc ba_stack_size = b_array_size

INCLUDE "../../z80/asm_ba_stack_size.asm"
