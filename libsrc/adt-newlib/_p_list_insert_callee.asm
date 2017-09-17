; void *p_list_insert(p_list_t *list, void *list_item, void *item)

SECTION code_clib
SECTION code_string

MODULE _p_list_insert_callee_sdcc
GLOBAL _p_list_insert_callee
GLOBAL p_list_insert_callee

defc _p_list_insert_callee = p_list_insert_callee

