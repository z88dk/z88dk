
; int ba_priority_queue_resize(ba_priority_queue_t *q, size_t n)

PUBLIC ba_priority_queue_resize

EXTERN asm_ba_priority_queue_resize

ba_priority_queue_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_ba_priority_queue_resize
