
; int bv_priority_queue_pop(bv_priority_queue_t *q)

XDEF _bv_priority_queue_pop

LIB _ba_priority_queue_pop

_bv_priority_queue_pop:

   jp _ba_priority_queue_pop

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_pop.asm"
