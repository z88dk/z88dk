
; size_t wa_priority_queue_size(wa_priority_queue_t *q)

SECTION seg_code_wa_priority_queue

PUBLIC _wa_priority_queue_size

_wa_priority_queue_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_wa_priority_queue_size

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_size.asm"
