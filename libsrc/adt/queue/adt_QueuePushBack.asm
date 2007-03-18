; int adt_QueuePushBack(struct adt_Queue *q, void *item)
; CALLER linkage for function pointers

XLIB adt_QueuePushBack

LIB adt_QueuePushBack_callee
XREF ASMDISP_ADT_QUEUEPUSHBACK_CALLEE

.adt_QueuePushBack

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_QueuePushBack_callee + ASMDISP_ADT_QUEUEPUSHBACK_CALLEE
