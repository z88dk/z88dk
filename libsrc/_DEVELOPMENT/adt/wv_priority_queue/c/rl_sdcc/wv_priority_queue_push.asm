
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)

XDEF wv_priority_queue_push

wv_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   call asm_wv_priority_queue_push
   pop ix
   
   ret
   
   INCLUDE "../../z80/asm_wv_priority_queue_push.asm"
