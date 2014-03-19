
; int wa_stack_push(wa_stack_t *s, void *item)

XDEF wa_stack_push_callee

LIB w_array_append_callee

defc wa_stack_push_callee = w_array_append_callee

INCLUDE "../../z80/asm_wa_stack_push.asm"
