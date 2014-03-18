
; int bv_stack_top(bv_stack_t *s)

XDEF bv_stack_top

LIB b_array_back

defc bv_stack_top = b_array_back

INCLUDE "../../z80/asm_bv_stack_top.asm"
