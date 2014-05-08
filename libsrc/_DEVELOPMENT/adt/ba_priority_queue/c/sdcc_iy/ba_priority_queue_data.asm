
; void *ba_priority_queue_data(ba_priority_queue_t *q)

PUBLIC _ba_priority_queue_data

_ba_priority_queue_data:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_data.asm"
