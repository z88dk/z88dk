
; int ba_priority_queue_empty(ba_priority_queue_t *q)

SECTION seg_code_ba_priority_queue

PUBLIC _ba_priority_queue_empty

_ba_priority_queue_empty:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_empty

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_empty.asm"
