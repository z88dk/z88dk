
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

XLIB p_forward_list_push_front

LIB p_forward_list_insert_after

;defc p_forward_list_push_front = p_forward_list_insert_after

p_forward_list_push_front:

   jp p_forward_list_insert_after
