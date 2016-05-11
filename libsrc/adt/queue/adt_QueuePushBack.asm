; int adt_QueuePushBack(struct adt_Queue *q, void *item)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_QueuePushBack
PUBLIC _adt_QueuePushBack

EXTERN adt_QueuePushBack_callee
EXTERN ASMDISP_ADT_QUEUEPUSHBACK_CALLEE

.adt_QueuePushBack
._adt_QueuePushBack

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_QueuePushBack_callee + ASMDISP_ADT_QUEUEPUSHBACK_CALLEE
