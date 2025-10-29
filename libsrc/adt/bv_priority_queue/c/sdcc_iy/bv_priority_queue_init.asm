
; bv_priority_queue_t *
; bv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_init

EXTERN asm_bv_priority_queue_init

_bv_priority_queue_init:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   
   push hl
   push hl
   push bc
   push de
   push af

   jp asm_bv_priority_queue_init
