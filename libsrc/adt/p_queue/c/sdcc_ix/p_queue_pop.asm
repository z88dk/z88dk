
; void *p_queue_pop(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_pop

EXTERN _p_forward_list_alt_pop_front

defc _p_queue_pop = _p_forward_list_alt_pop_front
