
; void *wa_priority_queue_pop(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_pop

EXTERN asm_wa_priority_queue_pop

defc wa_priority_queue_pop = asm_wa_priority_queue_pop

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wa_priority_queue_pop
defc _wa_priority_queue_pop = wa_priority_queue_pop
ENDIF

