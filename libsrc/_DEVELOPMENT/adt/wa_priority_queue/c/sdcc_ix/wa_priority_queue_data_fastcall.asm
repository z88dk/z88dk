
; void *wa_priority_queue_data_fastcall(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_data_fastcall

EXTERN asm_wa_priority_queue_data

defc _wa_priority_queue_data_fastcall = asm_wa_priority_queue_data
