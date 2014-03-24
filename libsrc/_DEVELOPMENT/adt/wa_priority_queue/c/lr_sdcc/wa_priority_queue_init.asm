
; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

XDEF wa_priority_queue_init

LIB asm_wa_priority_queue_init

wa_priority_queue_init:

   pop af
   exx
   pop bc
   exx
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   exx
   push bc
   push af
   
   push ix
   
   ld ixl.c
   ld ixh,b
   exx
   
   call asm_wa_priority_queue_init
   
   pop ix
   ret
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_init.asm"
