
; void *wa_priority_queue_data(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_data

EXTERN _ba_priority_queue_data

defc _wa_priority_queue_data = _ba_priority_queue_data
