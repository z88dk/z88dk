; void adt_QueueDeleteS(struct adt_Queue *q, void *delete)
; CALLER linkage for function pointers

PUBLIC adt_QueueDeleteS

EXTERN adt_QueueDeleteS_callee
EXTERN ASMDISP_ADT_QUEUEDELETES_CALLEE

.adt_QueueDeleteS

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_QueueDeleteS_callee + ASMDISP_ADT_QUEUEDELETES_CALLEE
