
; size_t ba_stack_size(ba_stack_t *s)

XDEF ba_stack_size

LIB b_array_size

ba_stack_size:

   jp b_array_size

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_size.asm"
