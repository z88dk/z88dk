
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_push_callee

EXTERN asm_wv_priority_queue_push

wv_priority_queue_push_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_wv_priority_queue_push
