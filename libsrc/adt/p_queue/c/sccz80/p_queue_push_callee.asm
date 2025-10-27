
; void p_queue_push(p_queue_t *q, void *item)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_push_callee

EXTERN p_forward_list_alt_push_back_callee

defc p_queue_push_callee = p_forward_list_alt_push_back_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_queue_push_callee
defc _p_queue_push_callee = p_queue_push_callee
ENDIF

