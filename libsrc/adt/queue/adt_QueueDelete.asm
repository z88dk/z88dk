; void adt_QueueDelete(struct adt_Queue *q, void *delete)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_QueueDelete
PUBLIC _adt_QueueDelete

EXTERN adt_QueueDelete_callee
EXTERN ASMDISP_ADT_QUEUEDELETE_CALLEE

.adt_QueueDelete
._adt_QueueDelete

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_QueueDelete_callee + ASMDISP_ADT_QUEUEDELETE_CALLEE
