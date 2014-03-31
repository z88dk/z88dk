
; int bv_stack_pop(bv_stack_t *s)

XDEF bv_stack_pop

LIB b_array_pop_back

bv_stack_pop:

   jp b_array_pop_back

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_pop.asm"
