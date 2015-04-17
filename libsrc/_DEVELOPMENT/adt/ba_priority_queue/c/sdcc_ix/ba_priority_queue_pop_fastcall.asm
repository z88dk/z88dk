
; int ba_priority_queue_pop_fastcall(ba_priority_queue_t *q)

SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_pop_fastcall

_ba_priority_queue_pop_fastcall:

   push ix
   
   call asm_ba_priority_queue_pop
   
   pop ix
   ret

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_pop.asm"
