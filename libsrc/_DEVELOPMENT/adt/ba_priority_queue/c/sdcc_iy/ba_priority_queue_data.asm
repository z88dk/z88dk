
; void *ba_priority_queue_data(ba_priority_queue_t *q)

SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_data

_ba_priority_queue_data:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_data

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_data.asm"
