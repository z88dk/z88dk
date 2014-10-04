
; int ba_priority_queue_pop(ba_priority_queue_t *q)

SECTION seg_code_ba_priority_queue

PUBLIC _ba_priority_queue_pop

_ba_priority_queue_pop:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_pop.asm"
