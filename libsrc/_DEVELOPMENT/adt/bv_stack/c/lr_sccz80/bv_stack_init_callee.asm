
; bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size)

XDEF bv_stack_init_callee

LIB b_vector_init_callee

defc bv_stack_init_callee = b_vector_init_callee

INCLUDE "../../z80/asm_bv_stack_init.asm"
