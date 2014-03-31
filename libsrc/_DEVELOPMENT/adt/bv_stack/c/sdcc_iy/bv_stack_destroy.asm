
; void bv_stack_destroy(bv_stack_t *s)

XDEF bv_stack_destroy

LIB b_vector_destroy

bv_stack_destroy:

   jp b_vector_destroy

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_destroy.asm"
