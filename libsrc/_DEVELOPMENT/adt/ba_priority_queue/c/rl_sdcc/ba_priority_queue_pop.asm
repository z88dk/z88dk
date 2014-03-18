
; int ba_priority_queue_pop(ba_priority_queue_t *q)

XDEF ba_priority_queue_pop

ba_priority_queue_pop:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   call asm_ba_priority_queue_pop
   pop ix
   
   ret

   INCLUDE "../../z80/asm_ba_priority_queue_pop.asm"
