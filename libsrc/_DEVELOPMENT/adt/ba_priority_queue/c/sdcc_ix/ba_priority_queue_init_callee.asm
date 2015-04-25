
; ba_priority_queue_t *
; ba_priority_queue_init_callee(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_init_callee, l0_ba_priority_queue_init_callee

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

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_init.asm"
