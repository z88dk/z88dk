
; int bv_priority_queue_empty(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_empty

EXTERN _ba_priority_queue_empty

defc _bv_priority_queue_empty = _ba_priority_queue_empty
