
; void p_queue_push(p_queue_t *q, void *item)

PUBLIC p_queue_push

EXTERN p_forward_list_alt_push_back

;defc p_queue_push = p_forward_list_alt_push_back

p_queue_push:

   jp p_forward_list_alt_push_back
