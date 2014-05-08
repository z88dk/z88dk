
; size_t ba_priority_queue_capacity(ba_priority_queue_t *q)

PUBLIC _ba_priority_queue_capacity

_ba_priority_queue_capacity:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_capacity.asm"
