
; bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size)

SECTION seg_code_bv_stack

PUBLIC bv_stack_init_callee

EXTERN b_vector_init_callee

defc bv_stack_init_callee = b_vector_init_callee

INCLUDE "adt/bv_stack/z80/asm_bv_stack_init.asm"
