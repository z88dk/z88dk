
; size_t ba_stack_size(ba_stack_t *s)

SECTION code_adt_ba_stack

PUBLIC ba_stack_size

defc ba_stack_size = asm_ba_stack_size

INCLUDE "adt/ba_stack/z80/asm_ba_stack_size.asm"
