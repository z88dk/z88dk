
; int wa_priority_queue_resize(wa_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_resize

EXTERN asm_wa_priority_queue_resize

wa_priority_queue_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_wa_priority_queue_resize
