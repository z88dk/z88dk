
; int bv_stack_reserve(bv_stack_t *s, size_t n)

XDEF bv_stack_reserve

LIB b_vector_reserve

bv_stack_reserve:

   jp b_vector_reserve

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_reserve.asm"
