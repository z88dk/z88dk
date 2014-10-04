
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)

SECTION seg_code_wv_priority_queue

PUBLIC _wv_priority_queue_push

_wv_priority_queue_push:

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
   
   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_push.asm"
