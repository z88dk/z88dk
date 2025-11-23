
; int bv_priority_queue_resize(bv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_resize_callee

EXTERN ba_priority_queue_resize_callee

defc bv_priority_queue_resize_callee = ba_priority_queue_resize_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_priority_queue_resize_callee
defc _bv_priority_queue_resize_callee = bv_priority_queue_resize_callee
ENDIF

