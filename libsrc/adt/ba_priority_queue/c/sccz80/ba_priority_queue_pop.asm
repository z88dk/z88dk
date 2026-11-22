
; int ba_priority_queue_pop(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_pop

EXTERN asm_ba_priority_queue_pop

defc ba_priority_queue_pop = asm_ba_priority_queue_pop

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_priority_queue_pop
defc _ba_priority_queue_pop = ba_priority_queue_pop
ENDIF

