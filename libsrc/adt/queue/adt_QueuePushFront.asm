; int adt_QueuePushFront(struct adt_Queue *q, void *item)
; CALLER linkage for function pointers

XLIB adt_QueuePushFront

LIB adt_QueuePushFront_callee
XREF ASMDISP_ADT_QUEUEPUSHFRONT_CALLEE

.adt_QueuePushFront

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_QueuePushFront_callee + ASMDISP_ADT_QUEUEPUSHFRONT_CALLEE
