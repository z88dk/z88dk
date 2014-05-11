
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

PUBLIC p_forward_list_push_front_callee

EXTERN p_forward_list_insert_after_callee

;defc p_forward_list_push_front_callee = p_forward_list_insert_after_callee

p_forward_list_push_front_callee:

   jp p_forward_list_insert_after_callee

INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_push_front.asm"
