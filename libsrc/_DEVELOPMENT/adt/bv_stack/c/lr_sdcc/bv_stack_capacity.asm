
; size_t bv_stack_capacity(bv_stack_t *s)

XDEF bv_stack_capacity

LIB b_vector_capacity

defc bv_stack_capacity = b_vector_capacity

INCLUDE "../../z80/asm_bv_stack_capacity.asm"
