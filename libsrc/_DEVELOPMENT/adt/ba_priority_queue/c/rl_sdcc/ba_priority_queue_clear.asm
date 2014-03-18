
; void ba_priority_queue_clear(ba_priority_queue_t *q)

XDEF ba_priority_queue_clear

ba_priority_queue_clear:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ba_priority_queue_clear

   INCLUDE "../../z80/asm_ba_priority_queue_clear.asm"
