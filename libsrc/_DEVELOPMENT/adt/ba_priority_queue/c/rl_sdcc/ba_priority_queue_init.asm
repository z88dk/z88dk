
; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

XDEF ba_priority_queue_init

ba_priority_queue_init:

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
