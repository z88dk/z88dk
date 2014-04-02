
; int ba_stack_empty(ba_stack_t *s)

XDEF _ba_stack_empty

LIB _b_array_empty

_ba_stack_empty:

   jp _b_array_empty

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_empty.asm"
