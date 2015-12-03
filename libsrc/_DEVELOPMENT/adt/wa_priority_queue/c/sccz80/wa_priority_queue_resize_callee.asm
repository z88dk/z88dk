
; int wa_priority_queue_resize(wa_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_resize_callee

EXTERN asm_wa_priority_queue_resize

wa_priority_queue_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_wa_priority_queue_resize
