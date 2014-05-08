
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)

PUBLIC _bv_priority_queue_push

_bv_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_push.asm"
