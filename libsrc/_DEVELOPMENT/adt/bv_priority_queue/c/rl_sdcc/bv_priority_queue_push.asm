
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)

XDEF bv_priority_queue_push

bv_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   call asm_bv_priority_queue_push
   pop ix
   
   ret
   
   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_push.asm"
