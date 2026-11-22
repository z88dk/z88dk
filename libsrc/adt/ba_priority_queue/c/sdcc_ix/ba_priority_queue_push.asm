
; int ba_priority_queue_push(ba_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_push

EXTERN l0_ba_priority_queue_push_callee

_ba_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_ba_priority_queue_push_callee
