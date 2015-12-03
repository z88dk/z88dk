
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_push

EXTERN asm_bv_priority_queue_push

bv_priority_queue_push:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_bv_priority_queue_push
