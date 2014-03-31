
; int bv_priority_queue_pop(bv_priority_queue_t *q)

XDEF bv_priority_queue_pop

LIB ba_priority_queue_pop

bv_priority_queue_pop:

   jp ba_priority_queue_pop

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_pop.asm"
