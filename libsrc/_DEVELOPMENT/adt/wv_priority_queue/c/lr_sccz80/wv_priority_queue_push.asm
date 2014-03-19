
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)

XLIB wv_priority_queue_push

LIB asm_wv_priority_queue_push

wv_priority_queue_push:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_wv_priority_queue_push
