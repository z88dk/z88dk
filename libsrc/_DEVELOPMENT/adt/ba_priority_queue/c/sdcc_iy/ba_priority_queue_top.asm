
; int ba_priority_queue_top(ba_priority_queue_t *q)

SECTION seg_code_ba_priority_queue

PUBLIC _ba_priority_queue_top

_ba_priority_queue_top:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_top.asm"
