
; void ba_stack_clear(ba_stack_t *s)

XDEF _ba_stack_clear

LIB _b_array_clear

_ba_stack_clear:

   jp _b_array_clear

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_clear.asm"
