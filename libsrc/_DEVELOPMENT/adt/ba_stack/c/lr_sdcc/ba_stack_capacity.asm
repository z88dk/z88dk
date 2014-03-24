
; size_t ba_stack_capacity(ba_stack_t *s)

XDEF ba_stack_capacity

LIB b_array_capacity

defc ba_stack_capacity = b_array_capacity

INCLUDE "adt/ba_stack/z80/asm_ba_stack_capacity.asm"
