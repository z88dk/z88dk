
; size_t bv_priority_queue_size(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_size

EXTERN _ba_priority_queue_size

defc _bv_priority_queue_size = _ba_priority_queue_size
