
; size_t ba_priority_queue_capacity(ba_priority_queue_t *q)

XDEF ba_priority_queue_capacity

ba_priority_queue_capacity:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ba_priority_queue_capacity

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_capacity.asm"
