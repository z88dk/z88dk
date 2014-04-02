
; int ba_priority_queue_push(ba_priority_queue_t *q, int c)

XDEF _ba_priority_queue_push

_ba_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   call asm_ba_priority_queue_push
   pop ix
   
   ret
   
   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_push.asm"
