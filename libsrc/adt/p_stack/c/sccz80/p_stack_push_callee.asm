
; void p_stack_push(p_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC p_stack_push_callee

EXTERN p_forward_list_insert_after_callee

defc p_stack_push_callee = p_forward_list_insert_after_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_stack_push_callee
defc _p_stack_push_callee = p_stack_push_callee
ENDIF

