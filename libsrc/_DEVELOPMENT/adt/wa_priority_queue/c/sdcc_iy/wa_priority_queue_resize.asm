
; int wa_priority_queue_resize(wa_priority_queue_t *q, size_t n)

SECTION seg_code_wa_priority_queue

PUBLIC _wa_priority_queue_resize

_wa_priority_queue_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_resize.asm"
