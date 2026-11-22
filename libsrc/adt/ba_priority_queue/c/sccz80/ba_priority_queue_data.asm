
; void *ba_priority_queue_data(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_data

EXTERN asm_ba_priority_queue_data

defc ba_priority_queue_data = asm_ba_priority_queue_data

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_priority_queue_data
defc _ba_priority_queue_data = ba_priority_queue_data
ENDIF

