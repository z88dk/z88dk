
; int ba_stack_push(ba_stack_t *s, int c)

SECTION code_adt_ba_stack

PUBLIC ba_stack_push_callee

EXTERN b_array_append_callee

defc ba_stack_push_callee = b_array_append_callee

INCLUDE "adt/ba_stack/z80/asm_ba_stack_push.asm"
