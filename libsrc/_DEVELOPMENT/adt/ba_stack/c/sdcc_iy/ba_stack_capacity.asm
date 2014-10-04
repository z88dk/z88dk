
; size_t ba_stack_capacity(ba_stack_t *s)

SECTION seg_code_ba_stack

PUBLIC _ba_stack_capacity

EXTERN _b_array_capacity

defc _ba_stack_capacity = _b_array_capacity

INCLUDE "adt/ba_stack/z80/asm_ba_stack_capacity.asm"
