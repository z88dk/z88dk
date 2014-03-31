
; int ba_stack_top(ba_stack_t *s)

XDEF ba_stack_top

LIB b_array_back

ba_stack_top:

   jp b_array_back

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_top.asm"
