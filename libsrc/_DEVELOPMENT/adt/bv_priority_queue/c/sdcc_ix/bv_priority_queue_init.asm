
; bv_priority_queue_t *
; bv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_init

_bv_priority_queue_init:

   pop af
   pop de
   pop bc
   pop hl
   exx
   pop bc
   
   push bc
   exx
   push hl
   push bc
   push de
   push af

   exx
   push bc
   exx
   
   ex (sp),ix

   call asm_bv_priority_queue_init
   
   pop ix
   ret   
   
   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_init.asm"
