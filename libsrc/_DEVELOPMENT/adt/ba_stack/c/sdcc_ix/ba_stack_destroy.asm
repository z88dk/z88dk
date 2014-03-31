
; void ba_stack_destroy(ba_stack_t *s)

XDEF ba_stack_destroy

LIB b_array_destroy

ba_stack_destroy:

   jp b_array_destroy

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_destroy.asm"
