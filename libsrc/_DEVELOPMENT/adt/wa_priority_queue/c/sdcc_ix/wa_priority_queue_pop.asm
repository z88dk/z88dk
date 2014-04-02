
; void *wa_priority_queue_pop(wa_priority_queue_t *q)

XDEF _wa_priority_queue_pop

_wa_priority_queue_pop:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   call asm_wa_priority_queue_pop
   pop ix
   
   ret

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_pop.asm"
