
; int wa_priority_queue_empty(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_empty

EXTERN asm_wa_priority_queue_empty

defc wa_priority_queue_empty = asm_wa_priority_queue_empty
