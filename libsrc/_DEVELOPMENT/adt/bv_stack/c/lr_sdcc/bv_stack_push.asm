
; int bv_stack_push(bv_stack_t *s, int c)

XDEF bv_stack_push

LIB b_vector_append

defc bv_stack_push = b_vector_append

INCLUDE "../../z80/asm_bv_stack_push.asm"
