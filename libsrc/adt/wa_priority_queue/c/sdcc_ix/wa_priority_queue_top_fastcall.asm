
; void *wa_priority_queue_top_fastcall(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_top_fastcall

EXTERN asm_wa_priority_queue_top

defc _wa_priority_queue_top_fastcall = asm_wa_priority_queue_top
