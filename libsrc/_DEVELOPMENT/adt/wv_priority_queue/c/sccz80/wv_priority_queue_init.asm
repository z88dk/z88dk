
; wv_priority_queue_t *
; wv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_init

EXTERN asm_wv_priority_queue_init

wv_priority_queue_init:

   pop af
   pop ix
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push ix
   push af
   
   jp asm_wv_priority_queue_init
