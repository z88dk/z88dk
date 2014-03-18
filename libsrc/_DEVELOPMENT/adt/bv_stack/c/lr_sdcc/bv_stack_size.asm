
; size_t bv_stack_size(bv_stack_t *s)

XDEF bv_stack_size

LIB b_vector_size

defc bv_stack_size = b_vector_size

INCLUDE "../../z80/asm_bv_stack_size.asm"
