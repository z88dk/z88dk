
; int p_stack_empty(p_stack_t *s)

SECTION seg_code_p_stack

PUBLIC p_stack_empty

defc p_stack_empty = asm_p_stack_empty

INCLUDE "adt/p_stack/z80/asm_p_stack_empty.asm"
