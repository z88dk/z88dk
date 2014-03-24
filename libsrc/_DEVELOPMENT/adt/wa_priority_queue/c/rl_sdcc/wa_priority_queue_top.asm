
; void *wa_priority_queue_top(wa_priority_queue_t *q)

XDEF wa_priority_queue_top

wa_priority_queue_top:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_wa_priority_queue_top

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_top.asm"
