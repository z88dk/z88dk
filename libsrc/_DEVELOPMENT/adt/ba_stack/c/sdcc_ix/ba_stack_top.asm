
; int ba_stack_top(ba_stack_t *s)

PUBLIC _ba_stack_top

EXTERN _b_array_back

_ba_stack_top:

   jp _b_array_back

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_top.asm"
