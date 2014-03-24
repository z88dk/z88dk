
; size_t wa_priority_queue_capacity(wa_priority_queue_t *q)

XDEF wa_priority_queue_capacity

wa_priority_queue_capacity:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_wa_priority_queue_capacity

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_capacity.asm"
