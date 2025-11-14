
; int p_queue_empty(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_empty

EXTERN _p_forward_list_empty

defc _p_queue_empty = _p_forward_list_empty
