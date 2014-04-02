
; void bv_priority_queue_clear(bv_priority_queue_t *q)

XDEF _bv_priority_queue_clear

LIB _ba_priority_queue_clear

_bv_priority_queue_clear:

   jp _ba_priority_queue_clear

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_clear.asm"
