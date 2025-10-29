
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_push

EXTERN l0_bv_priority_queue_push_callee

_bv_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_bv_priority_queue_push_callee
