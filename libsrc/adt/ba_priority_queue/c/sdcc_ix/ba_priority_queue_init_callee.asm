
; ba_priority_queue_t *
; ba_priority_queue_init_callee(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_init_callee, l0_ba_priority_queue_init_callee

EXTERN asm_ba_priority_queue_init

_ba_priority_queue_init_callee:

   pop af
   pop hl
   pop de
   pop bc
   exx
   pop bc
   push af

l0_ba_priority_queue_init_callee:

   push bc
   exx
   
   ex (sp),ix
   
   call asm_ba_priority_queue_init
   
   pop ix
   ret
