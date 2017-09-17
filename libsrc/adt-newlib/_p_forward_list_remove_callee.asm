; void *p_forward_list_remove(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_string

MODULE _p_forward_list_remove_callee_sdcc
GLOBAL _p_forward_list_remove_callee
GLOBAL p_forward_list_remove_callee

defc _p_forward_list_remove_callee = p_forward_list_remove_callee

