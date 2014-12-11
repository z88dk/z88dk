
; size_t p_stack_size(p_stack_t *s)

SECTION code_adt_p_stack

PUBLIC p_stack_size

defc p_stack_size = asm_p_stack_size

INCLUDE "adt/p_stack/z80/asm_p_stack_size.asm"
