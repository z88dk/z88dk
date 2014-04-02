
; int ba_stack_pop(ba_stack_t *s)

XDEF _ba_stack_pop

LIB _b_array_pop_back

_ba_stack_pop:

   jp _b_array_pop_back

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_pop.asm"
