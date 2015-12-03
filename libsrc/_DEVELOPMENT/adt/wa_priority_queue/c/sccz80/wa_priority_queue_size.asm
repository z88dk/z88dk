
; size_t wa_priority_queue_size(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_size

EXTERN asm_wa_priority_queue_size

defc wa_priority_queue_size = asm_wa_priority_queue_size
