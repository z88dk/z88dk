
; void wa_priority_queue_clear(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_clear

EXTERN _ba_priority_queue_clear

defc _wa_priority_queue_clear = _ba_priority_queue_clear
