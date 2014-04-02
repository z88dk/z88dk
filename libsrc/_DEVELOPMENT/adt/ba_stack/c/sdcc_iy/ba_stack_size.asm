
; size_t ba_stack_size(ba_stack_t *s)

XDEF _ba_stack_size

LIB _b_array_size

_ba_stack_size:

   jp _b_array_size

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_size.asm"
