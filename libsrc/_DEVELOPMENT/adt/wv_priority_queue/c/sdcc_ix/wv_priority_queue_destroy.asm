
; void wv_priority_queue_destroy(wv_priority_queue_t *q)

SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_destroy

EXTERN _bv_priority_queue_destroy

defc _wv_priority_queue_destroy = _bv_priority_queue_destroy

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_destroy.asm"
