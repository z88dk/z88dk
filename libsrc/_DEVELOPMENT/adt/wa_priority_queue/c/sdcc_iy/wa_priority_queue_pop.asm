
; void *wa_priority_queue_pop(wa_priority_queue_t *q)

XDEF wa_priority_queue_pop

wa_priority_queue_pop:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_pop.asm"
