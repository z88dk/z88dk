
; void wa_priority_queue_clear(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_clear

EXTERN asm_wa_priority_queue_clear

defc wa_priority_queue_clear = asm_wa_priority_queue_clear
