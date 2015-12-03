
; void *wa_priority_queue_pop_fastcall(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_pop_fastcall

EXTERN asm_wa_priority_queue_pop

defc _wa_priority_queue_pop_fastcall = asm_wa_priority_queue_pop
