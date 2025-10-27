
; void p_stack_push_callee(p_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_push_callee

EXTERN _p_forward_list_insert_after_callee

defc _p_stack_push_callee = _p_forward_list_insert_after_callee
