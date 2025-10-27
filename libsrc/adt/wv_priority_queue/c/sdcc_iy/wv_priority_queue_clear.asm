
; void wv_priority_queue_clear(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_clear

EXTERN _wa_priority_queue_clear

defc _wv_priority_queue_clear = _wa_priority_queue_clear
