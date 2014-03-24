
; bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size)

XDEF bv_stack_init

LIB b_vector_init

defc bv_stack_init = b_vector_init

INCLUDE "adt/bv_stack/z80/asm_bv_stack_init.asm"
