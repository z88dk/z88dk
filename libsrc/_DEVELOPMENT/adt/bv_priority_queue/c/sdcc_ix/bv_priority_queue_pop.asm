
; int bv_priority_queue_pop(bv_priority_queue_t *q)

PUBLIC _bv_priority_queue_pop

EXTERN _ba_priority_queue_pop

_bv_priority_queue_pop:

   jp _ba_priority_queue_pop

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_pop.asm"
