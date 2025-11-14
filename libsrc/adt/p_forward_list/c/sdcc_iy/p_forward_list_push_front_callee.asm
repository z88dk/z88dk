
; void p_forward_list_push_front_callee(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_push_front_callee

EXTERN _p_forward_list_insert_after_callee

defc _p_forward_list_push_front_callee = _p_forward_list_insert_after_callee
