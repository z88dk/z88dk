; void p_forward_list_push_back(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_string

MODULE _p_forward_list_push_back_callee_sdcc
GLOBAL _p_forward_list_push_back_callee
GLOBAL p_forward_list_push_back_callee

defc _p_forward_list_push_back_callee = p_forward_list_push_back_callee

