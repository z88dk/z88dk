
; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_init

EXTERN asm_ba_priority_queue_init

ba_priority_queue_init:

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push hl
   push af
   
   jp asm_ba_priority_queue_init
