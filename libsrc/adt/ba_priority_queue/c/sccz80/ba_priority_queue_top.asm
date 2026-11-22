
; int ba_priority_queue_top(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_top

EXTERN asm_ba_priority_queue_top

defc ba_priority_queue_top = asm_ba_priority_queue_top

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_priority_queue_top
defc _ba_priority_queue_top = ba_priority_queue_top
ENDIF

