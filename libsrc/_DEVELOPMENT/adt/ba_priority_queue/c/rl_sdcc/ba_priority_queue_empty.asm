
; int ba_priority_queue_empty(ba_priority_queue_t *q)

XDEF ba_priority_queue_empty

ba_priority_queue_empty:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ba_priority_queue_empty

   INCLUDE "../../z80/asm_ba_priority_queue_empty.asm"
