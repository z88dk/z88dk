
; size_t wa_stack_capacity(wa_stack_t *s)

XDEF wa_stack_capacity

defc wa_stack_capacity = asm_wa_stack_capacity

INCLUDE "../../z80/asm_wa_stack_capacity.asm"
