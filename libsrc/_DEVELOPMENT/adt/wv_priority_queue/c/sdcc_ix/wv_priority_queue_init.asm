
; wv_priority_queue_t *
; wv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION seg_code_wv_priority_queue

PUBLIC _wv_priority_queue_init

_wv_priority_queue_init:

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
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_wv_priority_queue_init
   
   pop ix
   ret

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_init.asm"
