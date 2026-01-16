
; void p_queue_clear(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_clear

EXTERN _p_forward_list_alt_init

defc _p_queue_clear = _p_forward_list_alt_init
