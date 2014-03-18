
; bv_priority_queue_t *
; bv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

XDEF bv_priority_queue_init

bv_priority_queue_init:

   pop af
   exx
   pop bc
   exx
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   exx
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_bv_priority_queue_init
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_bv_priority_queue_init.asm"
