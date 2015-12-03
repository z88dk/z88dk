
; int ba_priority_queue_push(ba_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_push

EXTERN asm_ba_priority_queue_push

ba_priority_queue_push:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_ba_priority_queue_push
