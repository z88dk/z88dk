
; void ba_priority_queue_clear(ba_priority_queue_t *q)

SECTION seg_code_ba_priority_queue

PUBLIC _ba_priority_queue_clear

_ba_priority_queue_clear:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_clear

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_clear.asm"
