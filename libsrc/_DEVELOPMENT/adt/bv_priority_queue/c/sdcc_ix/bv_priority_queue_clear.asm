
; void bv_priority_queue_clear(bv_priority_queue_t *q)

SECTION seg_code_bv_priority_queue

PUBLIC _bv_priority_queue_clear

EXTERN _ba_priority_queue_clear

defc _bv_priority_queue_clear = _ba_priority_queue_clear

INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_clear.asm"
