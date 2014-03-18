
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)

XDEF bv_priority_queue_push

bv_priority_queue_push:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push ix
   call asm_bv_priority_queue_push
   pop ix
   
   ret
   
   INCLUDE "../../z80/asm_bv_priority_queue_push.asm"
