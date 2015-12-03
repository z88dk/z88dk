
; size_t p_queue_size(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_size

EXTERN _p_forward_list_size

defc _p_queue_size = _p_forward_list_size
