
; void ba_stack_destroy(ba_stack_t *s)

XDEF _ba_stack_destroy

LIB _b_array_destroy

_ba_stack_destroy:

   jp _b_array_destroy

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_destroy.asm"
