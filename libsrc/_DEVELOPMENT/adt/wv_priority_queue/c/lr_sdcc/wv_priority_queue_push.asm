
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)

XDEF wv_priority_queue_push

wv_priority_queue_push:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push ix
   call asm_wv_priority_queue_push
   pop ix
   
   ret
   
   INCLUDE "../../z80/asm_wv_priority_queue_push.asm"
