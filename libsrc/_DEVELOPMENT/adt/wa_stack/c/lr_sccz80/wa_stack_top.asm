
; void *wa_stack_top(wa_stack_t *s)

XDEF wa_stack_top

defc wa_stack_top = asm_wa_stack_top

INCLUDE "../../z80/asm_wa_stack_top.asm"
