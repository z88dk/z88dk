; void adt_QueueDelete(struct adt_Queue *q, void *delete)
; CALLER linkage for function pointers

XLIB adt_QueueDelete

LIB adt_QueueDelete_callee
XREF ASMDISP_ADT_QUEUEDELETE_CALLEE

.adt_QueueDelete

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_QueueDelete_callee + ASMDISP_ADT_QUEUEDELETE_CALLEE
