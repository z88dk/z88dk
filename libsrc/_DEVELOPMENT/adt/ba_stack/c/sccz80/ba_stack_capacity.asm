
; size_t ba_stack_capacity(ba_stack_t *s)

SECTION seg_code_ba_stack

PUBLIC ba_stack_capacity

defc ba_stack_capacity = asm_ba_stack_capacity

INCLUDE "adt/ba_stack/z80/asm_ba_stack_capacity.asm"
