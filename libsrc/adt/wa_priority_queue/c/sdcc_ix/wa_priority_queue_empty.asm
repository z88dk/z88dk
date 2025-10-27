
; int wa_priority_queue_empty(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_empty

EXTERN _ba_priority_queue_empty

defc _wa_priority_queue_empty = _ba_priority_queue_empty
