
; void p_stack_push(p_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC p_stack_push

EXTERN p_forward_list_insert_after

defc p_stack_push = p_forward_list_insert_after

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_stack_push
defc _p_stack_push = p_stack_push
ENDIF

