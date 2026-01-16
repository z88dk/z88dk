
; void *wa_priority_queue_top(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_top

EXTERN asm_wa_priority_queue_top

defc wa_priority_queue_top = asm_wa_priority_queue_top

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wa_priority_queue_top
defc _wa_priority_queue_top = wa_priority_queue_top
ENDIF

