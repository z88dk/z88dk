
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

PUBLIC p_forward_list_push_front

EXTERN p_forward_list_insert_after

;defc p_forward_list_push_front = p_forward_list_insert_after

p_forward_list_push_front:

   jp p_forward_list_insert_after
