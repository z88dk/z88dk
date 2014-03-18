
; int ba_stack_push(ba_stack_t *s, int c)

XDEF ba_stack_push_callee

LIB b_array_append_callee

defc ba_stack_push_callee = b_array_append_callee

INCLUDE "../../z80/asm_ba_stack_push.asm"
