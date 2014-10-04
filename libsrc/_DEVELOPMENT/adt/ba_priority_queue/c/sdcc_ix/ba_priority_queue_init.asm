
; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION seg_code_ba_priority_queue

PUBLIC _ba_priority_queue_init

_ba_priority_queue_init:

   pop af
   pop hl
   pop de
   pop bc
   exx
   pop bc

   push bc
   exx
   push bc
   push de
   push hl
   push af
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_ba_priority_queue_init
   
   pop ix
   ret

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_init.asm"
