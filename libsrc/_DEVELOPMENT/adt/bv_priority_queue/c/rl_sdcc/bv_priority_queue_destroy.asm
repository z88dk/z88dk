
; void bv_priority_queue_destroy(bv_priority_queue_t *q)

XDEF bv_priority_queue_destroy

bv_priority_queue_destroy:

   pop af
   pop hl
   
   push hl
   push af
      
   jp asm_bv_priority_queue_destroy

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_destroy.asm"
