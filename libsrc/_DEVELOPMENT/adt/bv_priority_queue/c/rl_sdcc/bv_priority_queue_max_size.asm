
; size_t bv_priority_queue_max_size(bv_priority_queue_t *q)

XDEF bv_priority_queue_max_size

bv_priority_queue_max_size:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_bv_priority_queue_max_size

   INCLUDE "../../z80/asm_bv_priority_queue_max_size.asm"
