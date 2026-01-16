
; bv_priority_queue_t *
; bv_priority_queue_init_callee(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_init_callee, l0_bv_priority_queue_init_callee

EXTERN asm_bv_priority_queue_init

_bv_priority_queue_init_callee:

   pop af
   pop de
   pop bc
   pop hl
   exx
   pop bc
   
   push bc
   push hl
   push bc
   push de
   push af

l0_bv_priority_queue_init_callee:

   push bc
   exx
   
   ex (sp),ix

   call asm_bv_priority_queue_init
   
   pop ix
   ret   
