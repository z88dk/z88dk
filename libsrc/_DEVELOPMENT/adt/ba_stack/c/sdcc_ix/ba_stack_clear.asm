
; void ba_stack_clear(ba_stack_t *s)

XDEF ba_stack_clear

LIB b_array_clear

ba_stack_clear:

   jp b_array_clear

   INCLUDE "adt/ba_stack/asm_ba_stack_clear.asm"
