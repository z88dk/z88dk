
; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

XLIB ba_priority_queue_init

LIB asm_ba_priority_queue_init

ba_priority_queue_init:

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push ix
   push af
   
   jp asm_ba_priority_queue_init
