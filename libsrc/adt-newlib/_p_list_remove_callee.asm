; void *p_list_remove(p_list_t *list, void *item)

SECTION code_clib
SECTION code_string

MODULE _p_list_remove_callee_sdcc
GLOBAL _p_list_remove_callee
GLOBAL p_list_remove_callee

defc _p_list_remove_callee = p_list_remove_callee

