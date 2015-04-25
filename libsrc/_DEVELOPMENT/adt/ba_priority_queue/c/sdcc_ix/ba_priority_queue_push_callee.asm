
; int ba_priority_queue_push_callee(ba_priority_queue_t *q, int c)

SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_push_callee, l0_ba_priority_queue_push_callee

_ba_priority_queue_push_callee:

   pop af
   pop hl
   pop bc
   push af

l0_ba_priority_queue_push_callee:

   push ix
   call asm_ba_priority_queue_push
   pop ix
   
   ret
   
   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_push.asm"
