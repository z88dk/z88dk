
; int bv_priority_queue_pop(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_pop

EXTERN _ba_priority_queue_pop

defc _bv_priority_queue_pop = _ba_priority_queue_pop
