
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)

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
