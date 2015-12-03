
; int wv_priority_queue_push_callee(wv_priority_queue_t *q, void *item)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_push_callee

EXTERN asm_wv_priority_queue_push

_wv_priority_queue_push_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_wv_priority_queue_push
