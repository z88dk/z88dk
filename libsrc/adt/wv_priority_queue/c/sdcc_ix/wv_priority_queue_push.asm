
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_push

EXTERN l0_wv_priority_queue_push_callee

_wv_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_wv_priority_queue_push_callee
