
; int bv_stack_empty(bv_stack_t *s)

XDEF bv_stack_empty

LIB b_vector_empty

defc bv_stack_empty = b_vector_empty

INCLUDE "../../z80/asm_bv_stack_empty.asm"
