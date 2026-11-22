
; wv_priority_queue_t *
; wv_priority_queue_init_callee(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_init_callee, l0_wv_priority_queue_init_callee

EXTERN asm_wv_priority_queue_init

_wv_priority_queue_init_callee:

   pop af
   pop de
   pop bc
   pop hl
   exx
   pop bc
   push af

l0_wv_priority_queue_init_callee:

   push bc
   exx
   
   ex (sp),ix
   
   call asm_wv_priority_queue_init
   
   pop ix
   ret
