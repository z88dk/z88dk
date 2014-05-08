
; size_t ba_priority_queue_size(ba_priority_queue_t *q)

PUBLIC _ba_priority_queue_size

_ba_priority_queue_size:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_size.asm"
