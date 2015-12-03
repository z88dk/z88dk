
; size_t wa_priority_queue_capacity(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_capacity

EXTERN asm_wa_priority_queue_capacity

defc wa_priority_queue_capacity = asm_wa_priority_queue_capacity
