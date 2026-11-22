
; int bv_priority_queue_top(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_top

EXTERN _ba_priority_queue_top

defc _bv_priority_queue_top = _ba_priority_queue_top
