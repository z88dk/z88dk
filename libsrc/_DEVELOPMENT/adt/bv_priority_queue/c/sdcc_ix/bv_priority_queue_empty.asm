
; int bv_priority_queue_empty(bv_priority_queue_t *q)

PUBLIC _bv_priority_queue_empty

EXTERN _ba_priority_queue_empty

_bv_priority_queue_empty:

   jp _ba_priority_queue_empty

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_empty.asm"
