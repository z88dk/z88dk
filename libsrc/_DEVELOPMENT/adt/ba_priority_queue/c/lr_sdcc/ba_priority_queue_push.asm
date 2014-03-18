
; int ba_priority_queue_push(ba_priority_queue_t *q, int c)

XDEF ba_priority_queue_push

ba_priority_queue_push:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push ix
   call asm_ba_priority_queue_push
   pop ix
   
   ret
   
   INCLUDE "../../z80/asm_ba_priority_queue_push.asm"
