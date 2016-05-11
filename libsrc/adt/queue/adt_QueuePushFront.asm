; int adt_QueuePushFront(struct adt_Queue *q, void *item)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_QueuePushFront
PUBLIC _adt_QueuePushFront

EXTERN adt_QueuePushFront_callee
EXTERN ASMDISP_ADT_QUEUEPUSHFRONT_CALLEE

.adt_QueuePushFront
._adt_QueuePushFront

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_QueuePushFront_callee + ASMDISP_ADT_QUEUEPUSHFRONT_CALLEE
