
; size_t bv_priority_queue_size(bv_priority_queue_t *q)

XDEF _bv_priority_queue_size

LIB _ba_priority_queue_size

_bv_priority_queue_size:

   jp _ba_priority_queue_size

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_size.asm"
