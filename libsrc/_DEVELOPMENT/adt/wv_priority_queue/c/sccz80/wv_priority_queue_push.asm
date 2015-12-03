
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_push

EXTERN asm_wv_priority_queue_push

wv_priority_queue_push:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_wv_priority_queue_push
