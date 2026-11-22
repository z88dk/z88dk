
; void *wa_priority_queue_data(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_data

EXTERN asm_wa_priority_queue_data

defc wa_priority_queue_data = asm_wa_priority_queue_data

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wa_priority_queue_data
defc _wa_priority_queue_data = wa_priority_queue_data
ENDIF

