
; int ba_priority_queue_push_callee(ba_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_push_callee

EXTERN asm_ba_priority_queue_push

_ba_priority_queue_push_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_ba_priority_queue_push
