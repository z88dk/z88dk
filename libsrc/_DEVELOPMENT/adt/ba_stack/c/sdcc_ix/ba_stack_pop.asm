
; int ba_stack_pop(ba_stack_t *s)

XDEF ba_stack_pop

LIB b_array_pop_back

ba_stack_pop:

   jp b_array_pop_back

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_pop.asm"
