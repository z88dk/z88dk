
; size_t ba_priority_queue_size(ba_priority_queue_t *q)

XDEF ba_priority_queue_size

ba_priority_queue_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_size

   INCLUDE "../../z80/asm_ba_priority_queue_size.asm"
