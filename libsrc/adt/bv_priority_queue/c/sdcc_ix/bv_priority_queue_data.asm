
; void *bv_priority_queue_data(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_data

EXTERN _ba_priority_queue_data

defc _bv_priority_queue_data = _ba_priority_queue_data
