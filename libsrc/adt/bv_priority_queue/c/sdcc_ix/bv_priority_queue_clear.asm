
; void bv_priority_queue_clear(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_clear

EXTERN _ba_priority_queue_clear

defc _bv_priority_queue_clear = _ba_priority_queue_clear
