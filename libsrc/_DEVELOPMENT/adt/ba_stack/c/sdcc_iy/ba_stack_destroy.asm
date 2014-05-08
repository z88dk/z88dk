
; void ba_stack_destroy(ba_stack_t *s)

PUBLIC _ba_stack_destroy

EXTERN _b_array_destroy

_ba_stack_destroy:

   jp _b_array_destroy

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_destroy.asm"
