
; void *p_queue_pop(p_queue_t *q)

XDEF p_queue_pop

;defc p_queue_pop = asm_p_queue_pop

p_queue_pop:

   INCLUDE "adt/p_queue/z80/asm_p_queue_pop.asm"
