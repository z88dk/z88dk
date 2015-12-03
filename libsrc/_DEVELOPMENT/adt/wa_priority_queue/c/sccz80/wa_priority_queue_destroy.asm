
; void wa_priority_queue_destroy(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_destroy

EXTERN asm_wa_priority_queue_destroy

defc wa_priority_queue_destroy = asm_wa_priority_queue_destroy
