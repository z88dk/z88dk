
; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION seg_code_wa_priority_queue

PUBLIC wa_priority_queue_init_callee

wa_priority_queue_init_callee:

   pop hl
   pop ix
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_init.asm"
