
; void ba_priority_queue_destroy(ba_priority_queue_t *q)

XDEF ba_priority_queue_destroy

ba_priority_queue_destroy:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ba_priority_queue_destroy

   INCLUDE "../../z80/asm_ba_priority_queue_destroy.asm"
