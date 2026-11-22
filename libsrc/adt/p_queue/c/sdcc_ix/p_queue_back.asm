
; void *p_queue_back(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_back

EXTERN _p_forward_list_alt_back

defc _p_queue_back = _p_forward_list_alt_back
