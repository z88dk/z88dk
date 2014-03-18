
; void bv_stack_destroy(bv_stack_t *s)

XDEF bv_stack_destroy

LIB b_vector_destroy

defc bv_stack_destroy = b_vector_destroy

INCLUDE "../../z80/asm_bv_stack_destroy.asm"
