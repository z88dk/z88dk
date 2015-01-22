
; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_init

_wa_priority_queue_init:

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
   
   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_wa_priority_queue_init
   
   pop ix
   ret
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_init.asm"
