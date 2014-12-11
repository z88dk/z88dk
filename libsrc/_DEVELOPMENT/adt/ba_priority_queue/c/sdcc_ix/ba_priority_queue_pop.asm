
; int ba_priority_queue_pop(ba_priority_queue_t *q)

SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_pop

_ba_priority_queue_pop:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   call asm_ba_priority_queue_pop
   pop ix
   
   ret

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_pop.asm"
