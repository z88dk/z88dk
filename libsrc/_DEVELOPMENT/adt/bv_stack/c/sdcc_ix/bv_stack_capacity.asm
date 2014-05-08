
; size_t bv_stack_capacity(bv_stack_t *s)

PUBLIC _bv_stack_capacity

EXTERN _b_vector_capacity

_bv_stack_capacity:

   jp _b_vector_capacity

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_capacity.asm"
