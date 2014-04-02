
; int wa_priority_queue_resize(wa_priority_queue_t *q, size_t n)

XDEF _wa_priority_queue_resize

_wa_priority_queue_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   call asm_wa_priority_queue_resize
   pop ix
   
   ret
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_resize.asm"
