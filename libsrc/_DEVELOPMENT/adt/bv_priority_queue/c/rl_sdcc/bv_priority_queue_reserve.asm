
; int bv_priority_queue_reserve(bv_priority_queue_t *q, size_t n)

XDEF bv_priority_queue_reserve

bv_priority_queue_reserve:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_bv_priority_queue_reserve

   INCLUDE "../../z80/asm_bv_priority_queue_reserve.asm"
