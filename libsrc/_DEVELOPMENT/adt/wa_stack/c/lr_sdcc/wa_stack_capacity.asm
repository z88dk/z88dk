
; size_t wa_stack_capacity(wa_stack_t *s)

XDEF wa_stack_capacity

LIB w_array_capacity

defc wa_stack_capacity = w_array_capacity

INCLUDE "../../z80/asm_wa_stack_capacity.asm"
