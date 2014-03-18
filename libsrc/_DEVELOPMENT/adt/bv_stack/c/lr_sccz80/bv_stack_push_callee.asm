
; int bv_stack_push(bv_stack_t *s, int c)

XDEF bv_stack_push_callee

LIB b_vector_append_callee

defc bv_stack_push_callee = b_vector_append_callee

INCLUDE "../../z80/asm_bv_stack_push.asm"
