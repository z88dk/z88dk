
; int bv_stack_empty(bv_stack_t *s)

XDEF bv_stack_empty

defc bv_stack_empty = asm_bv_stack_empty

INCLUDE "../../z80/asm_bv_stack_empty.asm"
