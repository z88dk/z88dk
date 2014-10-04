
; void p_stack_push(p_stack_t *s, void *item)

SECTION seg_code_p_stack

PUBLIC p_stack_push_callee

EXTERN p_forward_list_insert_after_callee

defc p_stack_push_callee = p_forward_list_insert_after_callee

INCLUDE "adt/p_stack/z80/asm_p_stack_push.asm"
