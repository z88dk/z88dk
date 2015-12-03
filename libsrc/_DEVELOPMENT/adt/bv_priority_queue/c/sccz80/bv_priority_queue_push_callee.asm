
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_push

EXTERN asm_bv_priority_queue_push

bv_priority_queue_push:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_bv_priority_queue_push
