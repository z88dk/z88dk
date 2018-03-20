
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_push_callee

EXTERN asm_bv_priority_queue_push

bv_priority_queue_push_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_bv_priority_queue_push

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_priority_queue_push_callee
defc _bv_priority_queue_push_callee = bv_priority_queue_push_callee
ENDIF

