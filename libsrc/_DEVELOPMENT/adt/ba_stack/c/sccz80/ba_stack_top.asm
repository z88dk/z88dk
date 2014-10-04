
; int ba_stack_top(ba_stack_t *s)

SECTION seg_code_ba_stack

PUBLIC ba_stack_top

defc ba_stack_top = asm_ba_stack_top

INCLUDE "adt/ba_stack/z80/asm_ba_stack_top.asm"
