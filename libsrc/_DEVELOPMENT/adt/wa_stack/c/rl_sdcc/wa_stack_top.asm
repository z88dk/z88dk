
; void *wa_stack_top(wa_stack_t *s)

XDEF wa_stack_top

LIB w_array_back

defc wa_stack_top = w_array_back

INCLUDE "../../z80/asm_wa_stack_top.asm"
