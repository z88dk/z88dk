
; int bv_priority_queue_top(bv_priority_queue_t *q)

XDEF _bv_priority_queue_top

LIB _ba_priority_queue_top

_bv_priority_queue_top:

   jp _ba_priority_queue_top

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_top.asm"
