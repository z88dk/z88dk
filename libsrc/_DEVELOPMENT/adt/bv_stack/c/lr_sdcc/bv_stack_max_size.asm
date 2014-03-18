
; size_t bv_stack_max_size(bv_stack_t *s)

XDEF bv_stack_max_size

LIB b_vector_max_size

defc bv_stack_max_size = b_vector_max_size

INCLUDE "../../z80/asm_bv_stack_max_size.asm"
