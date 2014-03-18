
; int ba_priority_queue_top(ba_priority_queue_t *q)

XDEF ba_priority_queue_top

ba_priority_queue_top:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ba_priority_queue_top

   INCLUDE "../../z80/asm_ba_priority_queue_top.asm"
