
; void wa_priority_queue_destroy(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_destroy

EXTERN _ba_priority_queue_destroy

defc _wa_priority_queue_destroy = _ba_priority_queue_destroy
