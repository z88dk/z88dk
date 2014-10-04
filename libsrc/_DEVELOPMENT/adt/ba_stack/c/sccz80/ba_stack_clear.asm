
; void ba_stack_clear(ba_stack_t *s)

SECTION seg_code_ba_stack

PUBLIC ba_stack_clear

defc ba_stack_clear = asm_ba_stack_clear

INCLUDE "adt/ba_stack/z80/asm_ba_stack_clear.asm"
