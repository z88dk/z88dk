; int adt_QueuePushBack(struct adt_Queue *q, void *item)
; CALLER linkage for function pointers

PUBLIC adt_QueuePushBack

EXTERN adt_QueuePushBack_callee
EXTERN ASMDISP_ADT_QUEUEPUSHBACK_CALLEE

.adt_QueuePushBack

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_QueuePushBack_callee + ASMDISP_ADT_QUEUEPUSHBACK_CALLEE
