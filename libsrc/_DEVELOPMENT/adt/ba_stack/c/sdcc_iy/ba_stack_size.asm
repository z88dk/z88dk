
; size_t ba_stack_size(ba_stack_t *s)

PUBLIC _ba_stack_size

EXTERN _b_array_size

_ba_stack_size:

   jp _b_array_size

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_size.asm"
