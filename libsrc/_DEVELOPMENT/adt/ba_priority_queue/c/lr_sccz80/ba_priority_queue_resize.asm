
; int ba_priority_queue_resize(ba_priority_queue_t *q, size_t n)

XLIB ba_priority_queue_resize

LIB asm_ba_priority_queue_resize

ba_priority_queue_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_ba_priority_queue_resize
