
; void wa_stack_clear(wa_stack_t *s)

XDEF wa_stack_clear

LIB w_array_clear

defc wa_stack_clear = w_array_clear

INCLUDE "../../z80/asm_wa_stack_clear.asm"
