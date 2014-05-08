
; size_t ba_stack_capacity(ba_stack_t *s)

PUBLIC _ba_stack_capacity

EXTERN _b_array_capacity

_ba_stack_capacity:

   jp _b_array_capacity

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_capacity.asm"
