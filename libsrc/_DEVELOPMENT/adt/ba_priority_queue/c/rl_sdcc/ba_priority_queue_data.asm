
; void *ba_priority_queue_data(ba_priority_queue_t *q)

XDEF ba_priority_queue_data

ba_priority_queue_data:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ba_priority_queue_data

   INCLUDE "../../z80/asm_ba_priority_queue_data.asm"
