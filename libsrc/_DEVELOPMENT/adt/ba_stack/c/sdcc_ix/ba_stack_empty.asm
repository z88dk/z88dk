
; int ba_stack_empty(ba_stack_t *s)

PUBLIC _ba_stack_empty

EXTERN _b_array_empty

_ba_stack_empty:

   jp _b_array_empty

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_empty.asm"
