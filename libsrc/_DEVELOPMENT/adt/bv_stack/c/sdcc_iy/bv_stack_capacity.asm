
; size_t bv_stack_capacity(bv_stack_t *s)

XDEF bv_stack_capacity

LIB b_vector_capacity

bv_stack_capacity:

   jp b_vector_capacity

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_capacity.asm"
