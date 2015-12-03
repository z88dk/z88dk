
; void p_queue_push(p_queue_t *q, void *item)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_push

EXTERN p_forward_list_alt_push_back

defc p_queue_push = p_forward_list_alt_push_back
