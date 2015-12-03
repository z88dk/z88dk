
; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC wa_priority_queue_init_callee

EXTERN asm_wa_priority_queue_init

wa_priority_queue_init_callee:

   pop hl
   pop ix
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_wa_priority_queue_init
