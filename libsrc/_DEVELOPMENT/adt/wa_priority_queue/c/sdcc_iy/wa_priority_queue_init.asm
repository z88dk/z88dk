
; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

XDEF wa_priority_queue_init

LIB asm_wa_priority_queue_init

wa_priority_queue_init:

   pop af
   pop hl
   pop de
   pop bc
   pop ix
   
   push ix
   push bc
   push de
   push hl
   push af
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_init.asm"
