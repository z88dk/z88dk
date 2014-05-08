
; void ba_stack_clear(ba_stack_t *s)

PUBLIC _ba_stack_clear

EXTERN _b_array_clear

_ba_stack_clear:

   jp _b_array_clear

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_clear.asm"
