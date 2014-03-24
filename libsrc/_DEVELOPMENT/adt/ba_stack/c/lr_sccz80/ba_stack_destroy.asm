
; void ba_stack_destroy(ba_stack_t *s)

XDEF ba_stack_destroy

LIB b_array_destroy

;defc ba_stack_destroy = b_array_destroy

ba_stack_destroy:

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_destroy.asm"
