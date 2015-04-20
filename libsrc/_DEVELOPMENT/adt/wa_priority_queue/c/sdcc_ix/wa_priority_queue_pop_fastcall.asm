
; void *wa_priority_queue_pop_fastcall(wa_priority_queue_t *q)

SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_pop_fastcall

_wa_priority_queue_pop_fastcall:
   
   push ix
   call asm_wa_priority_queue_pop
   pop ix
   
   ret

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_pop.asm"
