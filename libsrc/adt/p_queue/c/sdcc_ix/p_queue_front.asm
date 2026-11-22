
; void *p_queue_front(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_front

EXTERN _p_forward_list_front

defc _p_queue_front = _p_forward_list_front
