
; int wa_priority_queue_push(wa_priority_queue_t *q, void *item)

XLIB wa_priority_queue_push

LIB asm_wa_priority_queue_push

wa_priority_queue_push:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_wa_priority_queue_push
