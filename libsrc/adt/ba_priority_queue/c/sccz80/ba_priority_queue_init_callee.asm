
; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_init_callee

EXTERN asm_ba_priority_queue_init

ba_priority_queue_init_callee:

   pop hl
   exx
   pop hl
   exx
   pop bc
   pop de
   ex (sp),hl
   push ix
   exx
   push hl
   pop ix
   exx

   call asm_ba_priority_queue_init
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_priority_queue_init_callee
defc _ba_priority_queue_init_callee = ba_priority_queue_init_callee
ENDIF

