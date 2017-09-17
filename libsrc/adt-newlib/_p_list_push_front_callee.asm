; void *p_list_push_front(p_list_t *list, void *item)

SECTION code_clib
SECTION code_string

MODULE _p_list_push_front_callee_sdcc
GLOBAL _p_list_push_front_callee
GLOBAL p_list_push_front_callee

defc _p_list_push_front_callee = p_list_push_front_callee

