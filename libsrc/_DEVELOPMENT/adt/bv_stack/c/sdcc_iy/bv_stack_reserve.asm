
; int bv_stack_reserve(bv_stack_t *s, size_t n)

PUBLIC _bv_stack_reserve

EXTERN _b_vector_reserve

_bv_stack_reserve:

   jp _b_vector_reserve

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_reserve.asm"
