
; int bv_priority_queue_top(bv_priority_queue_t *q)

XDEF bv_priority_queue_top

LIB ba_priority_queue_top

bv_priority_queue_top:

   jp ba_priority_queue_top

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_top.asm"
