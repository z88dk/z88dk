
; int ba_priority_queue_push(ba_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_push_callee

EXTERN asm_ba_priority_queue_push

ba_priority_queue_push_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_ba_priority_queue_push

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_priority_queue_push_callee
defc _ba_priority_queue_push_callee = ba_priority_queue_push_callee
ENDIF

