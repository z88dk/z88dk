
; int wv_priority_queue_push_callee(wv_priority_queue_t *q, void *item)

SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_push_callee, l0_wv_priority_queue_push_callee

_wv_priority_queue_push_callee:

   pop af
   pop hl
   pop bc
   push af

l0_wv_priority_queue_push_callee:

   push ix
   call asm_wv_priority_queue_push
   pop ix
   
   ret
   
   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_push.asm"
