
; void *bv_priority_queue_data(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_data

EXTERN asm_bv_priority_queue_data

defc bv_priority_queue_data = asm_bv_priority_queue_data

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_priority_queue_data
defc _bv_priority_queue_data = bv_priority_queue_data
ENDIF

