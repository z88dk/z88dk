
; void p_queue_push(p_queue_t *q, void *item)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_push

EXTERN _p_forward_list_alt_push_back

defc _p_queue_push = _p_forward_list_alt_push_back
